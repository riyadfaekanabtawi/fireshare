package com.betomaluje.android.fireshare.activities;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.annotation.TargetApi;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.app.ActivityCompat;
import android.support.v4.app.ActivityOptionsCompat;
import android.support.v4.util.Pair;
import android.support.v7.app.AppCompatActivity;
import android.text.TextUtils;
import android.transition.Explode;
import android.transition.Slide;
import android.transition.Transition;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.inputmethod.EditorInfo;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.betomaluje.android.fireshare.R;
import com.betomaluje.android.fireshare.bus.BusStation;
import com.betomaluje.android.fireshare.dialogs.LoadingDialog;
import com.betomaluje.android.fireshare.gcm.RegistrationIntentService;
import com.betomaluje.android.fireshare.models.User;
import com.betomaluje.android.fireshare.services.ServiceManager;
import com.betomaluje.android.fireshare.utils.SystemUtils;
import com.betomaluje.android.fireshare.utils.UserPreferences;
import com.squareup.otto.Subscribe;

import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * A login screen that offers login via email/password.
 */
public class LoginActivity extends AppCompatActivity {

    private final String TAG = LoginActivity.class.getSimpleName();

    public static final String VIEW_TAG_1 = "view1";
    public static final String VIEW_TAG_2 = "view2";
    public static final String VIEW_TAG_3 = "view3";

    @Bind(R.id.email)
    EditText mEmailView;

    @Bind(R.id.password)
    EditText mPasswordView;

    @Bind(R.id.login_progress)
    View mProgressView;

    @Bind(R.id.email_login_form)
    View mLoginFormView;

    private String regId;
    private LoadingDialog dialog;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        //for transitions
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            Transition explode = new Explode();
            explode.excludeTarget(android.R.id.statusBarBackground, true);
            explode.excludeTarget(android.R.id.navigationBarBackground, true);
            getWindow().setEnterTransition(explode);
            //getWindow().setReenterTransition(explode);

            Transition move = new Slide();
            move.excludeTarget(android.R.id.statusBarBackground, true);
            move.excludeTarget(android.R.id.navigationBarBackground, true);
            getWindow().setSharedElementEnterTransition(move);
            //getWindow().setSharedElementReturnTransition(move);
        }

        setContentView(R.layout.activity_login);
        ButterKnife.bind(this);

        regId = UserPreferences.using(LoginActivity.this).getTokenPush();

        if (regId.isEmpty()) {
            dialog = new LoadingDialog(LoginActivity.this);
            dialog.show();

            Intent intent = new Intent(this, RegistrationIntentService.class);
            startService(intent);
        } else {
            startApp();
        }
    }

    private void startApp() {
        if (!UserPreferences.using(LoginActivity.this).isNew()) {
            Log.e(TAG, "not new user");

            //check if we must do login again (after 30 days)
            if (UserPreferences.using(LoginActivity.this).mustLogin()) {
                Log.e(TAG, "date expired...so must login");
                initApp();
            } else {
                Log.e(TAG, "everything cool");
                startActivity(new Intent(LoginActivity.this, HomeActivity.class));
                finish();
            }

        } else {
            Log.e(TAG, "new user");
            initApp();
        }
    }

    @Subscribe
    public void getGCMToken(String token) {
        regId = token;

        UserPreferences.using(LoginActivity.this).saveTokenPush(token);
        if (!regId.isEmpty()) {
            dialog.cancel();
            dialog.dismiss();

            startApp();
        }
    }

    @Override
    protected void onStart() {
        super.onStart();
        BusStation.getBus().register(this);
    }

    @Override
    protected void onStop() {
        super.onStop();
        BusStation.getBus().unregister(this);

        if (dialog != null && dialog.isShowing()) {
            dialog.cancel();
            dialog.dismiss();
        }
    }

    private void initApp() {
        // Set up the login form.
        mPasswordView.setOnEditorActionListener(new TextView.OnEditorActionListener() {
            @Override
            public boolean onEditorAction(TextView textView, int id, KeyEvent keyEvent) {
                if (id == R.id.login || id == EditorInfo.IME_NULL) {
                    attemptLogin();
                    return true;
                }
                return false;
            }
        });

        findViewById(R.id.btn_register).setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                register();
            }
        });

        Button mEmailSignInButton = (Button) findViewById(R.id.btn_login);
        mEmailSignInButton.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View view) {
                attemptLogin();
            }
        });
    }

    private void register() {
        Pair<View, String> p1 = Pair.create(findViewById(R.id.btn_register), VIEW_TAG_1);
        Pair<View, String> p2 = Pair.create((View) mEmailView, VIEW_TAG_2);
        Pair<View, String> p3 = Pair.create((View) mPasswordView, VIEW_TAG_3);

        ActivityOptionsCompat options = ActivityOptionsCompat.makeSceneTransitionAnimation(LoginActivity.this, p1, p2, p3);
        ActivityCompat.startActivity(LoginActivity.this, new Intent(LoginActivity.this, RegisterActivity.class), options.toBundle());
    }

    /**
     * Attempts to sign in or register the account specified by the login form.
     * If there are form errors (invalid email, missing fields, etc.), the
     * errors are presented and no actual login attempt is made.
     */
    private void attemptLogin() {
        SystemUtils.hideKeyboard(LoginActivity.this);

        // Reset errors.
        mEmailView.setError(null);
        mPasswordView.setError(null);

        // Store values at the time of the login attempt.
        String email = mEmailView.getText().toString();
        String password = mPasswordView.getText().toString();

        boolean cancel = false;
        View focusView = null;

        // Check for a valid password, if the user entered one.
        if (TextUtils.isEmpty(password)) {
            mPasswordView.setError(getString(R.string.error_field_required));
            focusView = mPasswordView;
            cancel = true;
        }

        // Check for a valid email address.
        if (TextUtils.isEmpty(email)) {
            mEmailView.setError(getString(R.string.error_field_required));
            focusView = mEmailView;
            cancel = true;
        } else if (!isEmailValid(email)) {
            mEmailView.setError(getString(R.string.error_field_required));
            focusView = mEmailView;
            cancel = true;
        }

        if (cancel) {
            // There was an error; don't attempt login and focus the first
            // form field with an error.
            focusView.requestFocus();
        } else {
            // Show a progress spinner, and kick off a background task to
            // perform the user login attempt.
            showProgress(true);

            //do actual login
            ServiceManager.getInstance(LoginActivity.this).login(email, password, regId, new ServiceManager.ServiceManagerHandler<User>() {
                @Override
                public void loaded(User data) {
                    super.loaded(data);
                    startActivity(new Intent(LoginActivity.this, HomeActivity.class));
                    finish();
                }

                @Override
                public void error(String error) {
                    super.error(error);
                    Toast.makeText(LoginActivity.this, R.string.error_wrong_credentials, Toast.LENGTH_LONG).show();
                    showProgress(false);
                }
            });
        }
    }

    private boolean isEmailValid(String email) {
        return !TextUtils.isEmpty(email) && android.util.Patterns.EMAIL_ADDRESS.matcher(email).matches();
    }

    /**
     * Shows the progress UI and hides the login form.
     */
    @TargetApi(Build.VERSION_CODES.HONEYCOMB_MR2)
    private void showProgress(final boolean show) {
        // On Honeycomb MR2 we have the ViewPropertyAnimator APIs, which allow
        // for very easy animations. If available, use these APIs to fade-in
        // the progress spinner.
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB_MR2) {
            int shortAnimTime = getResources().getInteger(android.R.integer.config_shortAnimTime);

            mLoginFormView.setVisibility(show ? View.GONE : View.VISIBLE);
            mLoginFormView.animate().setDuration(shortAnimTime).alpha(
                    show ? 0 : 1).setListener(new AnimatorListenerAdapter() {
                @Override
                public void onAnimationEnd(Animator animation) {
                    mLoginFormView.setVisibility(show ? View.GONE : View.VISIBLE);
                }
            });

            mProgressView.setVisibility(show ? View.VISIBLE : View.GONE);
            mProgressView.animate().setDuration(shortAnimTime).alpha(
                    show ? 1 : 0).setListener(new AnimatorListenerAdapter() {
                @Override
                public void onAnimationEnd(Animator animation) {
                    mProgressView.setVisibility(show ? View.VISIBLE : View.GONE);
                }
            });
        } else {
            // The ViewPropertyAnimator APIs are not available, so simply show
            // and hide the relevant UI components.
            mProgressView.setVisibility(show ? View.VISIBLE : View.GONE);
            mLoginFormView.setVisibility(show ? View.GONE : View.VISIBLE);
        }
    }
}


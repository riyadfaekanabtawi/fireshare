package com.betomaluje.android.fireshare.activities;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.annotation.TargetApi;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.app.ActivityCompat;
import android.support.v7.app.AppCompatActivity;
import android.text.TextUtils;
import android.view.KeyEvent;
import android.view.MenuItem;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.betomaluje.android.fireshare.R;
import com.betomaluje.android.fireshare.models.User;
import com.betomaluje.android.fireshare.services.ServiceManager;
import com.betomaluje.android.fireshare.utils.ImageUtils;
import com.betomaluje.android.fireshare.utils.RoundedTransformation;
import com.betomaluje.android.fireshare.utils.UserPreferences;
import com.squareup.picasso.Picasso;
import com.squareup.picasso.Target;

import java.io.FileNotFoundException;

import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by betomaluje on 1/7/16.
 */
public class RegisterActivity extends AppCompatActivity {

    private final int IMAGE_PICK = 342;

    @Bind(R.id.email)
    EditText mEmailView;

    @Bind(R.id.name)
    EditText mNameView;

    @Bind(R.id.password)
    EditText mPasswordView;

    @Bind(R.id.password2)
    EditText mPasswordView2;

    @Bind(R.id.login_progress)
    View mProgressView;

    @Bind(R.id.email_login_form)
    View mLoginFormView;

    @Bind(R.id.photo)
    ImageView imageViewPhoto;

    @Bind(R.id.btn_register)
    Button btnRegister;

    @Bind(R.id.btn_cancel)
    Button btnCancel;

    private Bitmap photo;
    private boolean isUpdating;
    private User user;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_register);
        ButterKnife.bind(this);

        mPasswordView2.setOnEditorActionListener(new TextView.OnEditorActionListener() {
            @Override
            public boolean onEditorAction(TextView textView, int id, KeyEvent keyEvent) {
                if (id == R.id.login || id == EditorInfo.IME_NULL) {
                    attemptRegister();
                    return true;
                }
                return false;
            }
        });

        btnRegister.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                attemptRegister();
            }
        });

        imageViewPhoto.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                chooseImage();
            }
        });

        Bundle b = getIntent().getExtras();
        if (b != null && b.getBoolean("update", false)) {
            isUpdating = true;

            user = UserPreferences.using(RegisterActivity.this).getUser();
            mNameView.setText(user.getName());
            mEmailView.setText(user.getEmail());

            btnRegister.setText(R.string.button_update);

            Picasso.with(RegisterActivity.this).load(user.getUserImage(User.IMAGE_TYPE.SMALL))
                    .transform(new RoundedTransformation(8, 0))
                    .placeholder(R.mipmap.icon_user).into(new Target() {
                @Override
                public void onBitmapLoaded(Bitmap bitmap, Picasso.LoadedFrom from) {
                    photo = bitmap;
                    imageViewPhoto.setImageBitmap(bitmap);
                    imageViewPhoto.setBackgroundColor(Color.TRANSPARENT);
                }

                @Override
                public void onBitmapFailed(Drawable errorDrawable) {

                }

                @Override
                public void onPrepareLoad(Drawable placeHolderDrawable) {

                }
            });
        } else {
            isUpdating = false;
        }

        btnCancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent(RegisterActivity.this, LoginActivity.class));
                finish();
            }
        });
    }

    private void chooseImage() {
        Intent getIntent = new Intent(Intent.ACTION_GET_CONTENT);
        getIntent.setType("image/*");

        Intent pickIntent = new Intent(Intent.ACTION_PICK, android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
        pickIntent.setType("image/*");

        Intent chooserIntent = Intent.createChooser(getIntent, "Select Image");
        chooserIntent.putExtra(Intent.EXTRA_INITIAL_INTENTS, new Intent[]{pickIntent});

        startActivityForResult(chooserIntent, IMAGE_PICK);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == IMAGE_PICK && resultCode == RESULT_OK) {
            try {
                int size = Math.max(imageViewPhoto.getWidth(), imageViewPhoto.getHeight());

                photo = ImageUtils.scaleDown(getResources(),
                        BitmapFactory.decodeStream(getContentResolver().openInputStream(data.getData())),
                        size, true);

                if (photo != null) {
                    imageViewPhoto.setImageBitmap(photo);
                    imageViewPhoto.setBackgroundColor(Color.TRANSPARENT);
                } else {
                    Toast.makeText(RegisterActivity.this, R.string.error_image_problem, Toast.LENGTH_LONG).show();
                }

            } catch (FileNotFoundException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Attempts to sign in or register the account specified by the login form.
     * If there are form errors (invalid email, missing fields, etc.), the
     * errors are presented and no actual login attempt is made.
     */
    private void attemptRegister() {
        // Reset errors.
        mEmailView.setError(null);
        mPasswordView.setError(null);

        // Store values at the time of the login attempt.
        String email = mEmailView.getText().toString();
        String password = mPasswordView.getText().toString();
        String password2 = mPasswordView2.getText().toString();
        String name = mNameView.getText().toString();

        boolean cancel = false;
        View focusView = null;

        // Check for a valid password, if the user entered one.
        if ((!TextUtils.isEmpty(password) && !isPasswordValid(password)) || (!TextUtils.isEmpty(password2) && !isPasswordValid(password2))) {
            mPasswordView.setError(getString(R.string.error_field_required));
            focusView = mPasswordView;
            cancel = true;
        }

        if (!password.equals(password2)) {
            mPasswordView.setError(getString(R.string.error_wrong_credentials));
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

        if (photo == null) {
            cancel = true;
        }

        if (cancel) {
            // There was an error; don't attempt login and focus the first
            // form field with an error.
            if (focusView != null)
                focusView.requestFocus();
        } else {
            // Show a progress spinner, and kick off a background task to
            // perform the user login attempt.
            showProgress(true);

            //we hide the keyboard
            View view = this.getCurrentFocus();
            if (view != null) {
                InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
                imm.hideSoftInputFromWindow(view.getWindowToken(), InputMethodManager.HIDE_IMPLICIT_ONLY);
            }

            if (isUpdating) {
                //do actual register
                ServiceManager.getInstance(RegisterActivity.this).update(String.valueOf(user.getId()), email, name, UserPreferences.using(RegisterActivity.this).getTokenPush(),
                        password, password2, ImageUtils.imageToBase64String(photo), new ServiceManager.ServiceManagerHandler<User>() {
                            @Override
                            public void loaded(User data) {
                                super.loaded(data);
                                startActivity(new Intent(RegisterActivity.this, HomeActivity.class));
                                finish();
                            }

                            @Override
                            public void error(String error) {
                                super.error(error);
                                Toast.makeText(RegisterActivity.this, R.string.error_wrong_credentials, Toast.LENGTH_LONG).show();
                                showProgress(false);
                            }
                        });
            } else {
                //do actual register
                ServiceManager.getInstance(RegisterActivity.this).register(email, name, UserPreferences.using(RegisterActivity.this).getTokenPush(),
                        password, password2, ImageUtils.imageToBase64String(photo), new ServiceManager.ServiceManagerHandler<User>() {
                            @Override
                            public void loaded(User data) {
                                super.loaded(data);
                                startActivity(new Intent(RegisterActivity.this, HomeActivity.class));
                                finish();
                            }

                            @Override
                            public void error(String error) {
                                super.error(error);
                                Toast.makeText(RegisterActivity.this, R.string.error_wrong_credentials, Toast.LENGTH_LONG).show();
                                showProgress(false);
                            }
                        });
            }
        }
    }

    private boolean isEmailValid(String email) {
        return !TextUtils.isEmpty(email) && android.util.Patterns.EMAIL_ADDRESS.matcher(email).matches();
    }

    private boolean isPasswordValid(String password) {
        //TODO: Replace this with your own logic
        return password.length() > 4;
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

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            // Respond to the action bar's Up/Home button
            case android.R.id.home:
                ActivityCompat.finishAfterTransition(this);
                return true;
        }
        return super.onOptionsItemSelected(item);
    }

}

package com.parse.anyphone;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.parse.FunctionCallback;
import com.parse.LogInCallback;
import com.parse.ParseCloud;
import com.parse.ParseException;
import com.parse.ParseUser;

import org.json.JSONObject;

import java.util.HashMap;


public class LoginActivity extends AppCompatActivity {

    private TextView questionLabel, substituteLabel;
    private EditText textField;
    private Button sendCodeButton;

    public static String phoneNumber = null;
    private String token = null;
    private int code = 0;
    private int flag = 0; //If flag = 0 call the sendCode method, otherwise call the doLogin method.

    private ProgressBar progressBar;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        progressBar= (ProgressBar) findViewById(R.id.loadingSpinner);
        questionLabel = (TextView) findViewById(R.id.questionLabel);
        substituteLabel = (TextView) findViewById(R.id.subtitleLabel);
        textField = (EditText) findViewById(R.id.phoneNumberField);
        sendCodeButton = (Button) findViewById(R.id.sendCodeButton);

        sendCodeButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                sendCodeButton.setClickable(false);
                if(flag == 0)
                    sendCode();
                else
                    doLogin();
            }
        });
        phoneNumberUI();
    }

    private void phoneNumberUI() {
        flag = 0;
        questionLabel.setText("Please enter your phone number to log in:");
        substituteLabel.setText("This example is limited to 10-digit US numbers");
        textField.setHint(R.string.number_default);
        sendCodeButton.setClickable(true);

    }

    private void codeUI(){
        flag = 1;
        questionLabel.setText("Enter the 4-digit confirmation code:");
        substituteLabel.setText("It was sent in an SMS message to +1" + phoneNumber);
        textField.setText("");
        textField.setHint("1234");
        sendCodeButton.setClickable(true);
    }

    private void sendCode() {
        if(textField.getText().toString().length() != 10){
            Toast.makeText(getApplicationContext(),
                    "You must enter a 10-digit US phone number including area code.",
                    Toast.LENGTH_LONG).show();
            phoneNumberUI();
        }
        else{
            phoneNumber = String.valueOf(textField.getText());

            HashMap<String, Object> params = new HashMap<String, Object>();
            params.put("phoneNumber", phoneNumber);
            params.put("language", "en");
            progressBar.setVisibility(View.VISIBLE);
            ParseCloud.callFunctionInBackground("sendCode", params, new FunctionCallback<JSONObject>() {
                public void done(JSONObject response, ParseException e) {
                    progressBar.setVisibility(View.GONE);
                    if (e == null) {
                        Log.d("Cloud Response", "There were no exceptions! " + response.toString());
                        codeUI();
                    } else {
                        Log.d("Cloud Response", "Exception: " + response.toString() + e);
                        Toast.makeText(getApplicationContext(),
                                "Something went wrong.  Please try again." + e,
                                Toast.LENGTH_LONG).show();
                        phoneNumberUI();
                    }
                }
            });
        }
    }

    private void doLogin() {
        if(textField.getText().toString().length() != 4) {
            Toast.makeText(getApplicationContext(),
                    "You must enter the 4 digit code texted to your phone number.",
                    Toast.LENGTH_LONG).show();
            codeUI();
        } else {
            code = Integer.parseInt(textField.getText().toString());
            HashMap<String, Object> params = new HashMap<String, Object>();
            params.put("phoneNumber", phoneNumber);
            params.put("codeEntry", code);

            progressBar.setVisibility(View.VISIBLE);
            ParseCloud.callFunctionInBackground("logIn", params, new FunctionCallback<String>() {
                public void done(String response, ParseException e) {
                    progressBar.setVisibility(View.GONE);
                    if (e == null) {
                        token = response;
                        Log.d("Cloud Response", "There were no exceptions! " + response);
                        ParseUser.becomeInBackground(token, new LogInCallback() {
                            @Override
                            public void done(ParseUser parseUser, ParseException e) {
                                if (e == null){
                                    Log.d("Cloud Response", "There were no exceptions! ");
                                    Intent i = new Intent(LoginActivity.this, MainActivity.class);
                                    startActivity(i);
                                    finish();
                                }
                                else {
                                    Log.d("Cloud Response", "Exception: " + e);
                                    Toast.makeText(getApplicationContext(),
                                            "Something went wrong.  Please try again." + e,
                                            Toast.LENGTH_LONG).show();
                                    phoneNumberUI();
                                }
                            }
                        });
                    } else {
                        phoneNumberUI();
                        Log.d("Cloud Response", "Exception: " + response + e);
                        Toast.makeText(getApplicationContext(),
                                "Something went wrong.  Please try again.",
                                Toast.LENGTH_LONG).show();
                    }
                }
            });
        }
    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_login, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }
}

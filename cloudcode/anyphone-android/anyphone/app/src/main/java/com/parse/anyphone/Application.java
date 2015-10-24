package com.parse.anyphone;

import com.parse.Parse;

/**
 * Created by Madhav Chhura on 7/1/15.
 */
public class Application extends android.app.Application {
    public void onCreate(){

        //Add below your Parse project application and client keys.
        Parse.initialize(this, "ParseApplicationID", "ParseClientKey");
    }
}
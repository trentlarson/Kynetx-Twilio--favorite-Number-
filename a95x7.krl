ruleset a95x6 {
  meta {
    name "Tolman Family bookmark added"
    description <<
      
    >>
    author ""
    // Uncomment this line to require Marketplace purchase to use this app.
    // authz require user
    logging off
    key twilio {
      "account_sid" : "TWILIO SID",
      "auth_token"  : "TWILIO AUTH TOKEN"
    }
  }

  dispatch {
    // Some example dispatch domains
    // domain "example.com"
    // domain "other.example.com"
  }

  global {
  
  }

  rule bookmark_rule is active {
    select when pageview ".*" setting ()
    // pre {   }
    {
      twilio:place_call("8015601471", "8015601471", "http://webhooks.kynetx.com:3098/t/a95x6.dev/onanswer");
      notify("Call placed", "Call placed, Trent");
    }
  }
  
  rule bookmark_notify_rule is active {
    select when twilio onanswer
    {
      twilio:gather_start("picked") with action="picked";
      twilio:say("What is your favorite number?");
      twilio:gather_stop();
    }
  }
  
  rule bookmark_onpicked is active {
    select when twilio picked
    pre {
      favorite = event:param("Digits");
    }
    {
      twilio:say("Your favorite number is #{favorite}");
    }
  }
  
  rule if_three is active {
    select when twilio picked Digits "3" {
      twilio:say("You da man.");
      twilio:hangup();
    }
  }
  
  rule if_not_three is active {
    select when twilio picked Digits "[012456789]" {
      twilio:say("You are not the man.  Better luck next time.");
      twilio:hangup();
    }
  }
  

}
# Zagaku App 

[![Build Status](https://travis-ci.org/kyle-annen/ZagakuAppRails.svg?branch=master)](https://travis-ci.org/kyle-annen/ZagakuAppRails)

The Zagaku App aims to democratize and persist educational resources related to software learning and apprenticeship.

# Specific Goals

* Enhance communication of learning sessions
* Create a platform for the persistence of resources created for learning sessions

# Deployment

Environment variable are set through the Figaro gem. The application.yml is encrypted for Travis, however for production the application.example.yml should be copied and populated with related ENV values.

```
cp config/application.example.yml config/application.yml
```


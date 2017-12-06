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

# Run server in SSL

In order to test the iOS and Android apps, the server must run in SSL in order for the API calls to succeed.

First, generate a new key and certificate for the local host:

```bash
openssl req -x509 -sha256 -nodes -newkey rsa:2048 -days 365 -keyout localhost.key -out localhost.crt
```

Next, run the server with the cert and key (must be created in root directory of the project)

```bash
rails s -b 'ssl://localhost:3000?key=localhost.key&cert=localhost.crt'
```


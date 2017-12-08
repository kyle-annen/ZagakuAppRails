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

All environments need foreman in order to run Crono, the task scheduler.

```
bundle install foreman
```

# Run

To run the application, which consists of a rails application and Crono, a task scheduler, run:

```
foreman start
```

# Chronological task running

There are a number of jobs that are run on a schedule, mostly for ingestion of outside data (pull).  The configuration file for scheduling the jobs can be found here: 

`config/cronotab.rb`

To write a new job for scheduling, please follow the examples of existing jobs that are scheduled.  

In short, the job function `perform` should not accept any arguments, and remove any queue directive (usually first line after class declaration if using generator).

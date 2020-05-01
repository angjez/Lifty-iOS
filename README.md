# Lifty-iOS

An app for planning and executing workouts.

[Demo](https://youtu.be/oQQbCREco_A)

### Current features:
  * CRUD workouts
    * 4 workout types: for time (time cap), tabata & 2 crossfit-style types (AMRAP, EMOM)
    * 2 exercise types: for time and for repetitions
    * search bar with tabs for different workout types
  * CRUD workout plans
    * 1-12 weeks long plans
    * 1-7 workout days
    * unlimited workouts for one day
  * workout execution (workout timer)
    * exercise hints
    * extra timer for rest/work time for tabata and for each time period for EMOM
    * automatic round counters for EMOM and tabata
    * a lock button to prevent the user from accidentally leaving the app/workout during a workout
  * user accounts
    * fully editable accounts
    * password reminders
  * 6 achievements with levels 1-5 (newbie, beginner, intermediate, advanced, expert) depending on the amount of executed workouts or time spent working out
    * 4 workout-specyfic achievements
    * Time record - overall time spent working out achievement
    * Workout record - overall executed workouts
  * Cloud Firestore remote database
    * all workout/plan data is stored remotely as a Cloud Firestore JSON tree

### Planned features:

  * ~~CRUD workouts~~
  * ~~CRUD workout plans~~
  * ~~Cloud Firestore remote database~~
  * ~~workout execution (workout timer)~~
  * ~~achievements~~ (achievement on-tap descriptions & level descriptions soon to be added)
  * tap to add a round feature in timer for AMRAP
  * logging workouts (workout journal)
  * workout filtering by ~~type (implemented as search bar's feature) and~~ favourites
  * more login options (Google account, log in with Apple)

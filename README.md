*Please note that this is not compilable as is. The primary repository is on Whitgit (Whitworth's closed version of github)
# Task Manager

By David Martin and Andrew O'Kins

## Purpose

This project is designed to create a way for users to create, organize, and track tasks such as chores or errands. This was created in about 3 weeks as the final project for our database management class.

## Link to Web Application repository

https://github.com/AOKins/TaskManageWebsiteService

## Functions

- User Interfaces as a Mobile App & a Web App
  - Create Tasks & Edit Tasks
![alt text](https://github.com/mrbean1512/DBMS_Group/docs/dbms_readme/mobile_1.PNG)
    - Enter or change the name of the task
    - Enter or change the description of the task
    - Enter or change the date and time that the task is due
    - Enter or change the category/color of a task
  - Share Tasks
    - Search for other users and share tasks with them based on category
  - Complete Tasks
    - Marking a task as complete removes it from the user's view but keeps it in the dbms for possibly useful data

## Specification Overview

- Mobile Application
  - Dart & Flutter
  - Designed for Google Pixel 3 (but it should be compatible with most android phones)
- Web Application
  - Dart, CSS, Javascript
  - Designed for Chrome (a little buggy on Edge but it flies)
- DBMS
  - MySQL
  - All UIs interact with this

## Work Needed

- Mobile Application
  - Allow users to share content
  - Allow users to create new categories
- Web Application
  - Improve UI
- DBMS
  - Create three tier architecture to improve security and efficiency
    - Currently, data security for the mobile app is bad because it connects directly to the DBMS. This was originally supposed to be done via Php but we simply lacked the time to implement this. This currently is largest oversight of the project and will be the highest priority if development is continued.
  - Add some more data fields to improve usefulness of data

### Background

This project was created as the final project of our databases management class at Whitworth University. The project requirements were open ended; we were simply told to create some software that interacted with a DBMS. We decided to build a web interface and a mobile application that each were capable of interacting with one dbms via MySql. We used dart/flutter as the dominant language and teased some HTML and Javascript for a couple of technical solutions. The biggest difficulties were primarily caused by the small three week window that we had to create all of this. As a result, we were unable to implement all of the desired features of the app but we were able to successfully run the entire process and set up the critical foundation to expand in the future.

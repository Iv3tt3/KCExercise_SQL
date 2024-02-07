# Modeling and SQL Exercise

This SQL exercise involves implementing a previously designed database model created using draw.io. The project includes creating tables, inserting data, and performing two specific queries. The objective is to practice SQL database management and querying techniques.

Languages: English

## Content

1. 'SQLDiag.drawio' file is the following database schema diagram done in [draw.io](http://www.draw.io) 

![Database schema diagram](./diagram.png)

2. 'script.sql' SQL Script that create schema, set it, create tables and relations, insert data and run two queries.


# Exercise Statement

## Introduction: The Videoclub

A recently opened video rental store is facing challenges in managing the inventory and rental transactions. Owner believes that a proper software solution could streamline the process and improve customer satisfaction. Despite the existence of platforms like Netflix, he's determined to make his store successful.

## Requirements

Develop a database solution for the Videoclub

- Member Registration: The store needs to register its members. At a minimum, the system should capture their full name, date of birth, phone number, and identification number (e.g., DNI, Passport). Each member will be assigned a unique membership number for card issuance purposes.

- Member Address: It's optional, but the system should be able to record the correspondence address of the members for potential marketing campaigns. Only the postal code, street, number, and floor are required. It's assumed that the address will be from the same city as the video rental store.

- Movie Catalog: The store needs to maintain a catalog of movies. Multiple copies of each movie can be available for rental. For each movie, details such as title, release year, genre, director, and synopsis should be recorded.

- Rental Transactions: The system should keep track of which member has rented each copy of a movie and when. This involves recording the rental date and return date. If a movie hasn't been returned yet, it's considered on loan.

- Frequent Queries: The system should support frequent queries such as:
    - Which movies are currently available for rental (i.e., not on loan)?
    - What is the favorite genre of each member, to facilitate movie recommendations?

The SQL script must execute without errors.

Normalization principles should be applied wherever possible.


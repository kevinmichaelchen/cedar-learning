To illustrate how Cedar works, we'll borrow the organizational structures from the world of Harry Potter.

(All diagrams generated with [D2][d2]).

[d2]: https://d2lang.com

## The Org Units

We'll start with the organizational units. These are the confederations, ministrie, departments, and schools that encompass the entire organizational ontology.

![org-units](./1-org-units.svg)

The terminal (leaf) nodes in this tree (for now) are the schools in the wizarding world:

- Hogwarts
- Beauxbatons
- Ilvermorny

## The Users

Let's add some users, using two types of users:

- `Teachers`
- `Admins`

![users](./2-users.svg)

## The Classrooms

Let's add some classrooms.

![classrooms](./3-classrooms.svg)

Classrooms are viewable by anyone who works at the associated school, or who is employed by any higher, governing association.

For example, employees of the Ministry of Magic may view classrooms at Hogwarts
— since the Ministry oversees Hogwarts. However, Beauxbatons employees are
forbidden from viewing Howarts classes, and vice versa.

## The Students

What about students? Who should be allowed to view student data?

![students](./4-students.svg)

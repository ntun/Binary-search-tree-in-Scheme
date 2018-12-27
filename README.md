# Binary-search-tree-in-Scheme

This project is part of Fall 2018, CS 355: Programming Languages course at Illinois Wesleyan University. My project partner and I had to implement a binary search tree in Scheme, and then store the phone directory (name to phone number pair) in BST. The implementations can be found in `main.rkt` file.

Our BST data structure in Scheme is presented in the form of nested list `'(root (left subtree) (right subtree))`. In case of a leaf, it has the structore `'(root () ())`. Our BST implementation supports the following operations:

- `(leaf bst)`: a function `leaf` checks whether the input BST is a leaf or not
- `(left-subtree bst)`: returns the left subtree
- `(right-subtree bst)`: returns the right subtree
- `(bst-construct lst)`: constructs a BST from an input sorted list
- `(search-on-bst tree query)`: perform seach operation on a BST
- `(add lst ele)`: adds an input `ele` into the sorted list `lst` and still remains sorted
- `(add-to-bst bst ele)`: adds an input element `ele` to `bst` and rebalances `bst`
- `(sort-bst lst)`: takes a BST as an input and outputs a sorted list
- `(mergesort lst)`: mergesort on an input list `lst`

However, in order to store phone directory as a BST, we still need to consider the fact that each entry in the phone directory is a tuple of `<name, phone number>`. Thus, we added slight modifications in the aforementioned general BST operations by treating each node value as a pair, rather than a value. So, it should be noted that our implementation in `main.rkt` file only works for phone directory, but for general purpose BST (where each node is a value rather than a pair), we can just change the definitions of the following utility functions:

- `(lessThan name1 name2)`: checks whether the first names (string value) of the first pair is less than (in alphabetical) the second pair.
- `(greaterThan name1 name2)`: same as above, but for greater than operation
- `(equalTo name1 name2)`: same as above, but for equal to operation

Utimately, a `main` function is added to test out some functionality of the operations and display the results.


# Authors

Naing Lin Tun and Maishan Rumelia Rahman

# Contact

If you have any question, please contact me at ntun@iwu.edu.

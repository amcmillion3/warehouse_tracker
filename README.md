# Warehouse Tracker

This is a Ruby script that tracks product registrations, inventory, and customer orders in a warehouse. It processes input from standard input (stdin) and generates reports based on the provided commands.

## Data Representation

In this project, I chose to represent the data using hashes and wrapped everything in a class. Specifically:

- `WarehouseTracker` class: This class encapsulates the main functionality of the warehouse tracker. It maintains two instance variables, `@products` and `@orders`, to store product information and customer orders. 

- `@products` hash: This hash stores product information, such as the product name, price, and stock quantity. 

- `@orders` hash: This hash stores customer orders, with each customer having a nested hash containing their orders for various products. 

A hash was chosen for both because it allows multiple fields to be stored on each object. Also the key-value pairs make for easy retrieval of specific fields when necessary. 

## Input Processing

To process input commands, I implemented the `process_commands` method. This method splits each command into arguments and dynamically sends the appropriate method to the `WarehouseTracker` instance based on the first argument. For example, if the command is `"register hats $20.50"`, it will invoke the `register` method with the arguments `"hats"` and `"$20.50"`.

The use of the `send` method allows for dynamic method dispatch based on the command, making the code more extensible and maintainable. This approach also enables easy addition of new commands without modifying the code for each command individually.

## Reporting

The `report` method generates a report of customer orders and their total spending. It calculates the average order value for each customer and formats the report accordingly. Customers with no successful orders are marked as "n/a" in the report.

## Execution

To run the script, provide input via stdin. There are two ways to do this. From the project root directory run one of the following commands. 

```shell
ruby warehouse_tracker.rb < ./spec/mock_test_data/mock_input_1.txt

cat ./spec/mock_test_data/mock_input_1.txt | warehouse_tracker.rb
```
Note: you can create additional .txt inputs and they will function as long as they follow the same format. `./spec/mock_test_data/mock_input_2.txt` is one such additional test file. 
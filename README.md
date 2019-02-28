## Code Refactoring

Original Code - https://gist.github.com/sriddbs/b931b1a5508f9937a2f8ff44042b44d3

As the problem suggests, the orders_controller#create method is doing too many things, I tried to refactor the controller using service objects. And the current code base breaks the Single Responsibility Principle (SRP).

Generally, the principles are:

  *   Forget fat Models (don't allow them to become bloated) 

  * Keep Views dumb (so don't put complex logic there) 

  * And Controllers skinny (so don't put too much there) 

## Organizing the code

## Service Classes

  -  Orders
    - build - takes care of initializing the Order and adding the items from the Cart record to the Order instance. 
    - process - will calculate the total price and process the payment using credit card 
    - complete - set the **Order's** status attribute to **processed** and save the **Order** in the database 

  - Payments
    - credit card - takes care of charging the user with the total amount of the ordered items. 
    - Instantiating the **ActiveMerchant** client 
    - Using **ActiveMerchant**, check whether the credit card information is valid, if invalid, return error message 
    - If the credit card is valid, charge the card via **ActiveMerchant**, if charge fails, return a error message 

## Why this approach better

With this approach the code is more readable, testable and easily extendable. For instance if we want to introduce another payment method like debit card, we can extend the code by adding another class called DebitCard under the payments service without modifying any other part of the code.


Concerns are well separated, the actions related to order is taken care by Order service and payments are handled by Payments service and hence the code is not tightly coupled anymore.


## Other best practices

  - Use .freeze for constants 
    - In Ruby, constants are mutable. One of the things you can do to speed up your ruby app is to decrease the number of objects that are created. If we freeze string literals, the Ruby interpreter will only create one String object and will cache it for future use.


  - Move magic numbers and strings (hardcoded values) used in the application to constants, for ex:- the shipping fee and shipping method can be a constant 

# Grocy Main Flow and Functionality

This document outlines the main functionalities of Grocy, a household and grocery management application. The purpose of this document is to provide a clear understanding of the application's features to inform the development of a new version with a modern tech stack.

## Core Concepts

Grocy is built around a few core concepts that represent real-world items and activities in a household.

*   **Products**: Any item that you want to track. This is the central entity in Grocy's stock management. Products have properties like name, description, category, and default quantity units.
*   **Locations**: Physical places where products are stored (e.g., "Pantry", "Refrigerator").
*   **Shopping Locations**: Stores or places where you buy products.
*   **Quantity Units**: Units of measurement for products (e.g., "pieces", "grams", "liters"). The system supports conversions between units (e.g., 1 box = 6 pieces).
*   **Chores**: Recurring tasks or duties that need to be done in the household.
*   **Batteries**: A special type of item for tracking rechargeable batteries and their charge cycles.
*   **Tasks**: Ad-hoc tasks that need to be completed.
*   **Recipes**: Instructions for preparing a meal, including a list of ingredients (products) and steps.
*   **Meal Plan**: A schedule for what to eat on specific days.
*   **Equipment**: A place to keep track of user manuals, warranty information and other details about your household equipment.
*   **Userfields**: Grocy allows for customization by letting users add their own fields to core entities. This allows for a high degree of personalization.

## Main Functionality

The application is divided into several modules, each handling a specific aspect of household management.

### 1. Authentication and User Management

*   **Authentication**: Users can log in to the application. Access to the API is controlled by API keys.
*   **User Management**: The application supports multiple users. It's possible to create, edit, and delete users, as well as manage their permissions.
*   **Permissions**: Grocy has a permission system to control what actions each user can perform.

### 2. Inventory and Stock Management

This is the core module of Grocy. It allows users to keep track of the products they have at home.

*   **Products**:
    *   Create, edit, and delete products.
    *   Assign products to groups (categories).
    *   Define default locations and quantity units for each product.
    *   Attach pictures and other files to products.
*   **Locations**:
    *   Create, edit, and delete locations.
*   **Stock Operations**:
    *   **Purchase**: Add products to the stock. Users can specify the quantity, price, and expiration date.
    *   **Consume**: Remove products from the stock. This can be a partial or full removal.
    *   **Transfer**: Move products between locations.
    *   **Inventory**: Correct the current stock amount for a product.
    *   **Open**: Mark a product as opened. This is useful for tracking products that have a shorter shelf life after being opened.
*   **Stock Overview**:
    *   A dashboard showing the current stock levels.
    *   Products can be filtered by location, group, or other criteria.
    *   Highlights products that are expiring soon or are already expired.
*   **Barcode Support**:
    *   Products can have one or more barcodes associated with them.
    *   The system can look up products by their barcode.
    *   It's possible to perform stock operations (purchase, consume) by scanning a barcode.
    *   Integration with external barcode lookup services (e.g., OpenFoodFacts).
*   **Price Tracking**:
    *   The system stores the price of products per purchase.
    *   It can display a history of the price for each product.
    *   A report on spendings is available.
*   **Labels and Grocycode**:
    *   The system can generate labels for products and stock entries.
    *   It uses a custom "Grocycode" (a QR code) that embeds information about the product or stock entry. This can be used with a barcode scanner for quick actions.

### 3. Shopping Lists

*   Create and manage multiple shopping lists.
*   Add products to the shopping list, specifying the desired quantity.
*   The system can automatically add products to the shopping list based on stock levels (e.g., when a product is running low).
*   Add products from recipes to the shopping list.
*   Group items on the shopping list by product group.

### 4. Recipes and Meal Planning

*   **Recipes**:
    *   Create and manage recipes.
    *   Each recipe has a list of ingredients (products from the stock) with quantities.
    *   The system can check if the required ingredients for a recipe are currently in stock.
*   **Meal Plan**:
    *   Schedule recipes for specific days and meal times.
    *   The meal plan provides a calendar view of what is planned to be cooked.
    *   Missing ingredients for the planned meals can be added to the shopping list.

### 5. Chores and Tasks

*   **Chores**:
    *   Create and manage recurring chores.
    *   Define a schedule for each chore (e.g., daily, weekly, monthly).
    *   Track when a chore was last done and when it's due next.
    *   Assign chores to specific users.
*   **Tasks**:
    *   Create and manage ad-hoc tasks.
    *   Assign tasks to categories.
    *   Mark tasks as completed.

### 6. Battery Management

*   Track rechargeable batteries.
*   Record charge cycles for each battery.
*   Keep a journal of all battery-related events.

### 7. Equipment Tracking

*   Store information about household equipment (e.g., appliances).
*   Attach user manuals, warranty information, and other documents to equipment records.

### 8. Calendar and Scheduling

*   A calendar view that consolidates information from other modules:
    *   Product expiration dates.
    *   Chore due dates.
    *   Tasks due dates.
    *   Meal plan entries.
*   The calendar is available as an iCal feed, which can be subscribed to from external calendar applications.

### 9. Extensibility

*   **Userfields**: Users can add custom fields to entities like products, chores, etc. This allows for storing additional information that is not part of the default schema.
*   **User Entities**: Users can define their own entities with custom fields, and then create objects for these entities. This provides a way to manage custom collections of items.

### 10. API Access

*   Grocy provides a comprehensive REST API for all its functionalities.
*   API keys are used for authentication.
*   The API allows for integration with other applications and services.

## User Flow Examples

Here are a few examples of common user flows to illustrate how the different modules work together.

### Example 1: Adding a new product to the stock

1.  The user navigates to the "Products" list.
2.  If the product doesn't exist yet, they create a new product, providing a name, quantity unit, and product group.
3.  The user goes to the "Purchase" page.
4.  They select the product they want to add.
5.  They enter the quantity, price, and optionally an expiration date and a shopping location.
6.  The system adds the product to the stock. The new stock entry is visible in the "Stock Overview".

### Example 2: Creating a shopping list and adding items

1.  The user goes to the "Shopping List" page.
2.  They can add items to the list manually by selecting a product and entering a quantity.
3.  Alternatively, the system can suggest items to add to the list based on:
    *   Products that are running low in stock.
    *   Products that are about to expire.
    *   Missing ingredients for a planned meal.
4.  Once the shopping is done, the user can use the "Purchase" page to add the items from the shopping list to the stock in one go.

### Example 3: Planning a meal and consuming the ingredients

1.  The user creates a recipe with a list of ingredients.
2.  They go to the "Meal Plan" and add the recipe to a specific day.
3.  The system checks if all ingredients are available in stock. If not, the user can add the missing ingredients to the shopping list.
4.  When the user cooks the meal, they can "consume" the recipe from the meal plan.
5.  The system automatically removes the required quantities of the ingredients from the stock. 
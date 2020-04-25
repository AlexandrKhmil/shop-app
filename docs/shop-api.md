# /api

## /admin

| Method | URL | Description |
|:---:|---|---|
| GET | `/api/admin` | Auth admin |
| POST | `/api/admin/login` | Admin's Sign in|

## /user

| Method | URL | Description |
|:---:|---|---|
| GET | `/api/user` | Auth |
| POST | `/api/user/login` | Sign In |
| POST | `/api/user/register` | Sign Up |
| POST | `/api/user/change-password` | Change Password |

---

## /products

| Method | URL | Description |
|:---:|---|---|
| GET | `/api/products` | All list of all products (Catalog) |
| POST | `/api/products` | **Admin action**: Add new product |
| GET | `/api/products?from={start}&limit={size}` | Get specified qunatity list of products |
| GET | `/api/products?category={category}` | Get products from specified category |
| GET | `/api/products?tag={tagList}` | Get products with specified tag |
| GET | `/api/products?name={str}` | Get products with specified name |
| GET | `/api/products?price-from={min}&price-to={max}` | Get products with price from A to B |
| GET | `/api/products?rate={"ASC" || "DESC"}` | Get products with rating by ASC of DESC |
| GET | `/api/products?date={"ASC" || "DESC"}` | Get products with Date Adding by ASC of DESC |
| GET | `/api/products/{id}/` | Get all info about one specified product and some reviews |
| PUT | `/api/product/{id}/` | **Admin action**: Change info about product (Hide) |
| DELETE | `/api/product/{id}/` | **Admin action**: Delete product |
| POST | `/api/products/{productId}/rate` | Rate product |
| PUT | `/api/products/{productId}/rate` | Change rate of product |
| DELETE | `/api/products/{productId}/rate` | Delete rate of product |
| GET | `/api/products/{productId}/review` | Get secified number of reviews to product |
| GET | `/api/products/{productId}/reviews&from={start}&limit={size}` | Get secified number of reviews to product |
| POST | `/api/products/{productId}/reviews` | Add review to product |
| PUT | `/api/products/{productId}/reviews` | Change user's review |
| DELETE | `/api/products/{productId}/reviews` | Delete user's review |
| POST | `/api/products/{productId}/review/like` | Add Like to review |

---

## /orders

| Method | URL | Description |
|:---:|---|---|
| GET | `/api/orders`| Return list of orders of user |
| POST | `/api/orders` | Place Order |
| GET | `/api/orders/{id}` | Get info about specified order |
| POST | `/api/orders/{id}/accept` | **Admin action**: accept order |
| POST | `/api/orders/{id}/reject` | **Admin action**: Reject order |
| POST | `/api/orders/{id}/delete` | **Admin action**: Complete order |

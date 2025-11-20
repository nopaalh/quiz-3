<%@ page import="java.util.List" %>
<%@ page import="com.example.model.Product" %>
<%@ page import="com.example.model.Category" %>
<%@ page import="com.example.dao.ProductDAO" %>
<%@ page import="com.example.dao.CategoryDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Products</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    <h1>Manage Products</h1>
    <a href="index.jsp">Back to Home</a>
    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
    <p style="color: red;"><%= error %></p>
    <% } %>
    <h2>Add New Product</h2>
    <form action="product" method="post">
        <input type="hidden" name="action" value="add">
        <label for="name">Name:</label>
        <input type="text" id="name" name="name" required><br>
        <label for="price">Price:</label>
        <input type="number" id="price" name="price" required><br>
        <label for="stock">Stock:</label>
        <input type="number" id="stock" name="stock" required><br>
        <label for="categoryId">Category:</label>
        <select id="categoryId" name="categoryId" required>
            <%
                CategoryDAO catDao = new CategoryDAO();
                List<Category> categories = catDao.getAllCategories();
                for (Category cat : categories) {
            %>
            <option value="<%= cat.getId() %>"><%= cat.getName() %></option>
            <% } %>
        </select><br>
        <input type="submit" value="Add Product">
    </form>

    <h2>Search Products</h2>
    <form action="product" method="get">
        <input type="hidden" name="action" value="search">
        <label for="searchName">Search by Name:</label>
        <input type="text" id="searchName" name="searchName" required>
        <input type="submit" value="Search">
    </form>

    <h2>All Products</h2>
    <table>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Price</th>
            <th>Stock</th>
            <th>Category</th>
            <th>Actions</th>
        </tr>
        <%
            List<Product> products = (List<Product>) request.getAttribute("products");
            if (products == null) {
                ProductDAO dao = new ProductDAO();
                products = dao.getAllProducts();
            }
            for (Product prod : products) {
        %>
        <tr>
            <td><%= prod.getId() %></td>
            <td><%= prod.getName() %></td>
            <td><%= prod.getPrice() %></td>
            <td><%= prod.getStock() %></td>
            <td><%= prod.getCategoryName() %></td>
            <td>
                <a href="editProduct.jsp?id=<%= prod.getId() %>">Edit</a> |
                <form action="product" method="post" style="display:inline;">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="id" value="<%= prod.getId() %>">
                    <input type="submit" value="Delete" onclick="return confirm('Are you sure?')">
                </form>
            </td>
        </tr>
        <% } %>
    </table>
</body>
</html>

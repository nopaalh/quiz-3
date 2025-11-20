<%@ page import="com.example.model.Product" %>
<%@ page import="com.example.model.Category" %>
<%@ page import="com.example.dao.ProductDAO" %>
<%@ page import="com.example.dao.CategoryDAO" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Product</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    <h1>Edit Product</h1>
    <a href="products.jsp">Back to Products</a>
    <%
        int id = Integer.parseInt(request.getParameter("id"));
        ProductDAO dao = new ProductDAO();
        Product product = dao.getProductById(id);
        if (product != null) {
    %>
    <form action="product" method="post">
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="id" value="<%= product.getId() %>">
        <label for="name">Name:</label>
        <input type="text" id="name" name="name" value="<%= product.getName() %>" required><br>
        <label for="price">Price:</label>
        <input type="number" id="price" name="price" value="<%= product.getPrice() %>" required><br>
        <label for="stock">Stock:</label>
        <input type="number" id="stock" name="stock" value="<%= product.getStock() %>" required><br>
        <label for="categoryId">Category:</label>
        <select id="categoryId" name="categoryId" required>
            <%
                CategoryDAO catDao = new CategoryDAO();
                List<Category> categories = catDao.getAllCategories();
                for (Category cat : categories) {
            %>
            <option value="<%= cat.getId() %>" <%= cat.getId() == product.getCategoryId() ? "selected" : "" %>><%= cat.getName() %></option>
            <% } %>
        </select><br>
        <input type="submit" value="Update Product">
    </form>
    <% } else { %>
    <p>Product not found.</p>
    <% } %>
</body>
</html>

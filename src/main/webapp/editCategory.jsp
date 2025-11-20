<%@ page import="com.example.model.Category" %> <%@ page
import="com.example.dao.CategoryDAO" %> <%@ page
contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
  <head>
    <title>Edit Category</title>
    <link rel="stylesheet" type="text/css" href="css/style.css" />
  </head>
  <body>
    <h1>Edit Category</h1>
    <a href="categories.jsp">Back to Categories</a>
    <% int id = Integer.parseInt(request.getParameter("id")); CategoryDAO dao =
    new CategoryDAO(); Category category = dao.getCategoryById(id); if (category
    != null) { %>
    <form action="category" method="post">
      <input type="hidden" name="action" value="update" />
      <input type="hidden" name="id" value="<%= category.getId() %>" />
      <label for="name">Name:</label>
      <input
        type="text"
        id="name"
        name="name"
        value="<%= category.getName() %>"
        required
      />
      <input type="submit" value="Update Category" />
    </form>
    <% } else { %>
    <p>Category not found.</p>
    <% } %>
  </body>
</html>

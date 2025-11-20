<%@ page import="java.util.List" %>
<%@ page import="com.example.model.Product" %>
<%@ page import="com.example.model.Category" %>
<%@ page import="com.example.dao.ProductDAO" %>
<%@ page import="com.example.dao.CategoryDAO" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    Locale indonesia = new Locale("id", "ID");
    NumberFormat rupiahFormat = NumberFormat.getCurrencyInstance(indonesia);

    String inputName = (String) session.getAttribute("inputName");
    String shouldOpenModal = (String) session.getAttribute("openModal");

    if(shouldOpenModal != null) {
        session.removeAttribute("inputName");
        session.removeAttribute("openModal");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Inventory Management System</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; }
        @keyframes slideIn { from { transform: translateX(100%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }
        @keyframes fadeOut { 0% { opacity: 1; } 80% { opacity: 1; } 100% { opacity: 0; pointer-events: none; } }
        .toast-notification { animation: slideIn 0.5s ease-out, fadeOut 4s 1s forwards; }
    </style>
</head>
<body class="bg-gray-50 text-gray-800 min-h-screen p-8">

<%
    String errorMsg = (String) session.getAttribute("errorMessage");
    String successMsg = (String) session.getAttribute("successMessage");

    if (errorMsg != null) {
%>
<div class="toast-notification fixed top-5 right-5 z-50 bg-white border-l-4 border-red-500 shadow-2xl rounded-lg p-4 flex items-start gap-3 max-w-sm">
    <div class="text-red-500 mt-0.5"><i class="fa-solid fa-circle-exclamation text-xl"></i></div>
    <div>
        <h4 class="font-bold text-red-600 text-sm">Failed!</h4>
        <p class="text-sm text-gray-600 mt-1"><%= errorMsg %></p>
    </div>
    <button onclick="this.parentElement.remove()" class="text-gray-400 hover:text-gray-600 ml-auto"><i class="fa-solid fa-xmark"></i></button>
</div>
<% session.removeAttribute("errorMessage"); }
    if (successMsg != null) { %>
<div class="toast-notification fixed top-5 right-5 z-50 bg-white border-l-4 border-green-500 shadow-2xl rounded-lg p-4 flex items-start gap-3 max-w-sm">
    <div class="text-green-500 mt-0.5"><i class="fa-solid fa-circle-check text-xl"></i></div>
    <div>
        <h4 class="font-bold text-green-600 text-sm">Success!</h4>
        <p class="text-sm text-gray-600 mt-1"><%= successMsg %></p>
    </div>
    <button onclick="this.parentElement.remove()" class="text-gray-400 hover:text-gray-600 ml-auto"><i class="fa-solid fa-xmark"></i></button>
</div>
<% session.removeAttribute("successMessage"); } %>

<div class="max-w-7xl mx-auto">
    <div class="mb-8">
        <h1 class="text-2xl font-bold text-slate-900">Inventory Management System</h1>
        <p class="text-slate-500 mt-1">Easily manage categories and product stock</p>
    </div>

    <div class="flex space-x-4 mb-6 bg-gray-100 p-1 rounded-lg w-fit">
        <button class="px-6 py-2 bg-white shadow-sm rounded-md text-sm font-medium text-gray-900 flex items-center gap-2">
            <i class="fa-solid fa-box-open"></i> Products
        </button>
        <a href="categories.jsp" class="px-6 py-2 hover:bg-gray-200 rounded-md text-sm font-medium text-gray-500 flex items-center gap-2 transition-colors">
            <i class="fa-solid fa-layer-group"></i> Categories
        </a>
    </div>

    <div class="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
        <div class="p-6 flex flex-col md:flex-row justify-between items-center gap-4">
            <div>
                <h2 class="text-lg font-semibold text-gray-900">Product Management</h2>
                <p class="text-sm text-gray-500">Manage product stock and information</p>
            </div>
            <button onclick="document.getElementById('addModal').showModal()" class="bg-slate-900 hover:bg-slate-800 text-white px-5 py-2.5 rounded-lg text-sm font-medium flex items-center gap-2 transition-colors">
                <i class="fa-solid fa-plus"></i> Add Product
            </button>
        </div>

        <div class="px-6 pb-6">
            <form action="product" method="get" class="relative">
                <input type="hidden" name="action" value="search">
                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                    <i class="fa-solid fa-magnifying-glass text-gray-400"></i>
                </div>
                <input type="text" name="searchName" class="bg-gray-50 border border-gray-200 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full pl-10 p-3" placeholder="Search product...">
            </form>
        </div>

        <div class="overflow-x-auto">
            <table class="w-full text-sm text-left text-gray-500">
                <thead class="text-xs text-gray-700 uppercase bg-white border-b">
                <tr>
                    <th scope="col" class="px-6 py-4 font-semibold">ID</th>
                    <th scope="col" class="px-6 py-4 font-semibold">Product Name</th>
                    <th scope="col" class="px-6 py-4 font-semibold">Category</th>
                    <th scope="col" class="px-6 py-4 font-semibold text-right">Price</th>
                    <th scope="col" class="px-6 py-4 font-semibold text-center">Stock</th>
                    <th scope="col" class="px-6 py-4 font-semibold text-center">Actions</th>
                </tr>
                </thead>
                <tbody>
                <%
                    List<Product> products = (List<Product>) request.getAttribute("products");
                    if (products == null) {
                        ProductDAO dao = new ProductDAO();
                        products = dao.getAllProducts();
                    }
                    if (products != null && !products.isEmpty()) {
                        for (Product prod : products) {
                %>
                <tr class="bg-white border-b hover:bg-gray-50 transition-colors">
                    <td class="px-6 py-4"><%= prod.getId() %></td>
                    <td class="px-6 py-4 font-medium text-gray-900"><%= prod.getName() %></td>
                    <td class="px-6 py-4">
                        <span class="bg-gray-100 text-gray-800 text-xs font-medium px-2.5 py-1 rounded border border-gray-200"><%= prod.getCategoryName() %></span>
                    </td>
                    <td class="px-6 py-4 text-right"><%= rupiahFormat.format(prod.getPrice()) %></td>
                    <td class="px-6 py-4 text-center">
                        <span class="bg-slate-900 text-white text-xs font-medium px-3 py-1 rounded-full"><%= prod.getStock() %></span>
                    </td>
                    <td class="px-6 py-4 text-center">
                        <div class="flex justify-center gap-2">
                            <button type="button"
                                    data-id="<%= prod.getId() %>"
                                    data-name="<%= prod.getName() %>"
                                    data-price="<%= prod.getPrice() %>"
                                    data-stock="<%= prod.getStock() %>"
                                    data-category="<%= prod.getCategoryId() %>"
                                    onclick="openEditModal(this)"
                                    class="p-2 text-gray-500 hover:text-blue-600 hover:bg-blue-50 rounded-full border border-gray-200 transition-colors" title="Edit">
                                <i class="fa-solid fa-pen"></i>
                            </button>

                            <a href="product?action=delete&id=<%= prod.getId() %>" onclick="return confirm('Are you sure you want to delete this?')" class="p-2 text-gray-500 hover:text-red-600 hover:bg-red-50 rounded-full border border-gray-200 transition-colors" title="Delete">
                                <i class="fa-solid fa-trash"></i>
                            </a>
                        </div>
                    </td>
                </tr>
                <% } } else { %>
                <tr><td colspan="6" class="text-center py-8 text-gray-500">No data available.</td></tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<dialog id="addModal" class="p-0 rounded-lg shadow-xl backdrop:bg-gray-900/50 w-full max-w-md">
    <div class="bg-white rounded-lg">
        <div class="flex justify-between items-center p-4 border-b">
            <h3 class="text-lg font-semibold text-gray-900">Add New Product</h3>
            <button onclick="document.getElementById('addModal').close()" class="text-gray-400 hover:text-gray-900"><i class="fa-solid fa-xmark text-xl"></i></button>
        </div>
        <form action="product" method="post" class="p-4 space-y-4">
            <input type="hidden" name="action" value="add">
            <div>
                <label class="block mb-1 text-sm font-medium text-gray-900">Product Name</label>
                <input type="text" name="name" value="<%= inputName != null ? inputName : "" %>" required class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg block w-full p-2.5">
            </div>
            <div class="grid grid-cols-2 gap-4">
                <div><label class="block mb-1 text-sm font-medium text-gray-900">Price</label><input type="number" name="price" required class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg block w-full p-2.5"></div>
                <div><label class="block mb-1 text-sm font-medium text-gray-900">Stock</label><input type="number" name="stock" required class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg block w-full p-2.5"></div>
            </div>
            <div>
                <label class="block mb-1 text-sm font-medium text-gray-900">Category</label>
                <select name="categoryId" required class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg block w-full p-2.5">
                    <%
                        CategoryDAO catDao = new CategoryDAO();
                        List<Category> categories = catDao.getAllCategories();
                        if(categories != null) { for (Category cat : categories) {
                    %>
                    <option value="<%= cat.getId() %>"><%= cat.getName() %></option>
                    <% } } %>
                </select>
            </div>
            <div class="flex justify-end gap-2 pt-4">
                <button type="button" onclick="document.getElementById('addModal').close()" class="text-gray-700 bg-white border border-gray-300 font-medium rounded-lg text-sm px-5 py-2.5 hover:bg-gray-100">Cancel</button>
                <button type="submit" class="text-white bg-slate-900 hover:bg-slate-800 font-medium rounded-lg text-sm px-5 py-2.5">Save</button>
            </div>
        </form>
    </div>
</dialog>

<dialog id="editModal" class="p-0 rounded-lg shadow-xl backdrop:bg-gray-900/50 w-full max-w-md">
    <div class="bg-white rounded-lg">
        <div class="flex justify-between items-center p-4 border-b">
            <h3 class="text-lg font-semibold text-gray-900">Edit Product</h3>
            <button onclick="document.getElementById('editModal').close()" class="text-gray-400 hover:text-gray-900"><i class="fa-solid fa-xmark text-xl"></i></button>
        </div>
        <form action="product" method="post" class="p-4 space-y-4">
            <input type="hidden" name="action" value="update">
            <input type="hidden" id="edit-id" name="id">

            <div>
                <label class="block mb-1 text-sm font-medium text-gray-900">Product Name</label>
                <input type="text" id="edit-name" name="name" required class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg block w-full p-2.5">
            </div>
            <div class="grid grid-cols-2 gap-4">
                <div>
                    <label class="block mb-1 text-sm font-medium text-gray-900">Price</label>
                    <input type="number" id="edit-price" name="price" required class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg block w-full p-2.5">
                </div>
                <div>
                    <label class="block mb-1 text-sm font-medium text-gray-900">Stock</label>
                    <input type="number" id="edit-stock" name="stock" required class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg block w-full p-2.5">
                </div>
            </div>
            <div>
                <label class="block mb-1 text-sm font-medium text-gray-900">Category</label>
                <select id="edit-category" name="categoryId" required class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg block w-full p-2.5">
                    <%
                        if(categories != null) { for (Category cat : categories) {
                    %>
                    <option value="<%= cat.getId() %>"><%= cat.getName() %></option>
                    <% } } %>
                </select>
            </div>
            <div class="flex justify-end gap-2 pt-4">
                <button type="button" onclick="document.getElementById('editModal').close()" class="text-gray-700 bg-white border border-gray-300 font-medium rounded-lg text-sm px-5 py-2.5 hover:bg-gray-100">Cancel</button>
                <button type="submit" class="text-white bg-blue-600 hover:bg-blue-700 font-medium rounded-lg text-sm px-5 py-2.5">Update Product</button>
            </div>
        </form>
    </div>
</dialog>

<script>
    function openEditModal(button) {
        var id = button.getAttribute("data-id");
        var name = button.getAttribute("data-name");
        var price = button.getAttribute("data-price");
        var stock = button.getAttribute("data-stock");
        var category = button.getAttribute("data-category");

        document.getElementById("edit-id").value = id;
        document.getElementById("edit-name").value = name;
        document.getElementById("edit-price").value = price;
        document.getElementById("edit-stock").value = stock;
        document.getElementById("edit-category").value = category;

        document.getElementById("editModal").showModal();
    }

    <% if(shouldOpenModal != null) { %>
    document.getElementById('addModal').showModal();
    <% } %>
</script>

</body>
</html>
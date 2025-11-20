<%@ page import="java.util.List" %>
<%@ page import="com.example.model.Category" %>
<%@ page import="com.example.dao.CategoryDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="id">
<head>
    <title>Sistem Manajemen Kategori</title>
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
    <div><h4 class="font-bold text-red-600 text-sm">Gagal!</h4><p class="text-sm text-gray-600 mt-1"><%= errorMsg %></p></div>
    <button onclick="this.parentElement.remove()" class="ml-auto text-gray-400"><i class="fa-solid fa-xmark"></i></button>
</div>
<% session.removeAttribute("errorMessage"); }
    if (successMsg != null) { %>
<div class="toast-notification fixed top-5 right-5 z-50 bg-white border-l-4 border-green-500 shadow-2xl rounded-lg p-4 flex items-start gap-3 max-w-sm">
    <div class="text-green-500 mt-0.5"><i class="fa-solid fa-circle-check text-xl"></i></div>
    <div><h4 class="font-bold text-green-600 text-sm">Berhasil!</h4><p class="text-sm text-gray-600 mt-1"><%= successMsg %></p></div>
    <button onclick="this.parentElement.remove()" class="ml-auto text-gray-400"><i class="fa-solid fa-xmark"></i></button>
</div>
<% session.removeAttribute("successMessage"); } %>

<div class="max-w-7xl mx-auto">
    <div class="mb-8">
        <h1 class="text-2xl font-bold text-slate-900">Sistem Manajemen Inventori</h1>
        <p class="text-slate-500 mt-1">Kelola kategori barang</p>
    </div>

    <div class="flex space-x-4 mb-6 bg-gray-100 p-1 rounded-lg w-fit">
        <a href="index.jsp" class="px-6 py-2 hover:bg-gray-200 rounded-md text-sm font-medium text-gray-500 flex items-center gap-2 transition-colors">
            <i class="fa-solid fa-box-open"></i> Produk
        </a>
        <button class="px-6 py-2 bg-white shadow-sm rounded-md text-sm font-medium text-gray-900 flex items-center gap-2">
            <i class="fa-solid fa-layer-group"></i> Kategori
        </button>
    </div>

    <div class="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
        <div class="p-6 flex flex-col md:flex-row justify-between items-center gap-4">
            <div>
                <h2 class="text-lg font-semibold text-gray-900">Daftar Kategori</h2>
                <p class="text-sm text-gray-500">Kelola nama kategori produk</p>
            </div>
            <button onclick="document.getElementById('addCatModal').showModal()" class="bg-slate-900 hover:bg-slate-800 text-white px-5 py-2.5 rounded-lg text-sm font-medium flex items-center gap-2 transition-colors">
                <i class="fa-solid fa-plus"></i> Tambah Kategori
            </button>
        </div>

        <div class="overflow-x-auto">
            <table class="w-full text-sm text-left text-gray-500">
                <thead class="text-xs text-gray-700 uppercase bg-white border-b">
                <tr>
                    <th scope="col" class="px-6 py-4 font-semibold w-24">ID</th>
                    <th scope="col" class="px-6 py-4 font-semibold">Nama Kategori</th>
                    <th scope="col" class="px-6 py-4 font-semibold text-center">Jumlah Produk</th>
                    <th scope="col" class="px-6 py-4 font-semibold text-center w-48">Aksi</th>
                </tr>
                </thead>
                <tbody>
                <%
                    CategoryDAO dao = new CategoryDAO();
                    List<Category> categories = dao.getAllCategories();
                    if (categories != null && !categories.isEmpty()) {
                        for (Category cat : categories) {
                            // Panggil method hitung jumlah produk
                            int productCount = dao.getProductCountByCategoryId(cat.getId());
                %>
                <tr class="bg-white border-b hover:bg-gray-50 transition-colors">
                    <td class="px-6 py-4"><%= cat.getId() %></td>
                    <td class="px-6 py-4 font-medium text-gray-900"><%= cat.getName() %></td>

                    <td class="px-6 py-4 text-center">
                        <span class="bg-slate-900 text-white text-xs font-medium px-3 py-1 rounded-full">
                            <%= productCount %>
                        </span>
                    </td>

                    <td class="px-6 py-4 text-center">
                        <div class="flex justify-center gap-2">
                            <button type="button"
                                    onclick="openEditModal('<%= cat.getId() %>', '<%= cat.getName() %>')"
                                    class="p-2 text-gray-500 hover:text-blue-600 hover:bg-blue-50 rounded-full border border-gray-200 transition-colors" title="Edit">
                                <i class="fa-solid fa-pen"></i>
                            </button>

                            <a href="category?action=delete&id=<%= cat.getId() %>"
                               onclick="return confirm('Yakin hapus kategori ini?')"
                               class="p-2 text-gray-500 hover:text-red-600 hover:bg-red-50 rounded-full border border-gray-200 transition-colors" title="Delete">
                                <i class="fa-solid fa-trash"></i>
                            </a>
                        </div>
                    </td>
                </tr>
                <%      }
                } else { %>
                <tr><td colspan="4" class="text-center py-8 text-gray-500">Belum ada kategori.</td></tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<dialog id="addCatModal" class="p-0 rounded-lg shadow-xl backdrop:bg-gray-900/50 w-full max-w-md">
    <div class="bg-white rounded-lg">
        <div class="flex justify-between items-center p-4 border-b">
            <h3 class="text-lg font-semibold text-gray-900">Tambah Kategori</h3>
            <button onclick="document.getElementById('addCatModal').close()" class="text-gray-400 hover:text-gray-900"><i class="fa-solid fa-xmark"></i></button>
        </div>
        <form action="category" method="post" class="p-4 space-y-4">
            <input type="hidden" name="action" value="add">
            <div>
                <label class="block mb-1 text-sm font-medium text-gray-900">Nama Kategori</label>
                <input type="text" name="name" required class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg block w-full p-2.5">
            </div>
            <div class="flex justify-end gap-2 pt-4">
                <button type="button" onclick="document.getElementById('addCatModal').close()" class="text-gray-700 bg-white border border-gray-300 font-medium rounded-lg text-sm px-5 py-2.5 hover:bg-gray-100">Batal</button>
                <button type="submit" class="text-white bg-slate-900 hover:bg-slate-800 font-medium rounded-lg text-sm px-5 py-2.5">Simpan</button>
            </div>
        </form>
    </div>
</dialog>

<dialog id="editCatModal" class="p-0 rounded-lg shadow-xl backdrop:bg-gray-900/50 w-full max-w-md">
    <div class="bg-white rounded-lg">
        <div class="flex justify-between items-center p-4 border-b">
            <h3 class="text-lg font-semibold text-gray-900">Edit Kategori</h3>
            <button onclick="document.getElementById('editCatModal').close()" class="text-gray-400 hover:text-gray-900"><i class="fa-solid fa-xmark"></i></button>
        </div>
        <form action="category" method="post" class="p-4 space-y-4">
            <input type="hidden" name="action" value="update">
            <input type="hidden" id="edit-id" name="id">
            <div>
                <label class="block mb-1 text-sm font-medium text-gray-900">Nama Kategori</label>
                <input type="text" id="edit-name" name="name" required class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg block w-full p-2.5">
            </div>
            <div class="flex justify-end gap-2 pt-4">
                <button type="button" onclick="document.getElementById('editCatModal').close()" class="text-gray-700 bg-white border border-gray-300 font-medium rounded-lg text-sm px-5 py-2.5 hover:bg-gray-100">Batal</button>
                <button type="submit" class="text-white bg-blue-600 hover:bg-blue-700 font-medium rounded-lg text-sm px-5 py-2.5">Update</button>
            </div>
        </form>
    </div>
</dialog>

<script>
    function openEditModal(id, name) {
        document.getElementById("edit-id").value = id;
        document.getElementById("edit-name").value = name;
        document.getElementById("editCatModal").showModal();
    }
</script>

</body>
</html>
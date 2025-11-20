package com.example.servlet;

import com.example.model.Category;
import com.example.dao.CategoryDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class CategoryServlet extends HttpServlet {
    private CategoryDAO dao = new CategoryDAO();

    // 1. doPost UNTUK MENANGANI FORM (TAMBAH & EDIT/UPDATE)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        try {
            if ("add".equals(action)) {
                String name = request.getParameter("name");
                Category category = new Category();
                category.setName(name);
                dao.addCategory(category);
                session.setAttribute("successMessage", "Kategori berhasil ditambahkan!");

            } else if ("update".equals(action)) {
                // Ini menangani form dari Modal Edit
                int id = Integer.parseInt(request.getParameter("id"));
                String name = request.getParameter("name");

                Category category = new Category(id, name);
                dao.updateCategory(category);

                session.setAttribute("successMessage", "Kategori berhasil diperbarui!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Gagal memproses data: " + e.getMessage());
        }

        response.sendRedirect("categories.jsp");
    }

    // 2. doGet UNTUK MENANGANI LINK (HAPUS)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        try {
            if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));

                // Cek apakah kategori masih punya produk?
                if (dao.categoryHasProducts(id)) {
                    session.setAttribute("errorMessage", "Gagal! Kategori ini masih memiliki produk di dalamnya.");
                } else {
                    dao.deleteCategory(id);
                    session.setAttribute("successMessage", "Kategori berhasil dihapus.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error Sistem: " + e.getMessage());
        }

        response.sendRedirect("categories.jsp");
    }
}
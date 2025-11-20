package com.example.servlet;

import java.io.IOException;

import com.example.dao.CategoryDAO;
import com.example.model.Category;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class CategoryServlet extends HttpServlet {
    private CategoryDAO dao = new CategoryDAO();

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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        try {
            if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));

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
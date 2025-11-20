package com.example.servlet;

import com.example.model.Product;
import com.example.dao.ProductDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class ProductServlet extends HttpServlet {
    
    private ProductDAO dao = new ProductDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        try {
            if ("add".equals(action)) {
                String name = request.getParameter("name");
                int price = Integer.parseInt(request.getParameter("price"));
                int stock = Integer.parseInt(request.getParameter("stock"));
                int categoryId = Integer.parseInt(request.getParameter("categoryId"));
                
                if (dao.productExists(name)) {
                    session.setAttribute("errorMessage", "Gagal! Produk '" + name + "' sudah tersedia.");
                    session.setAttribute("inputName", name);
                    session.setAttribute("openModal", "true"); 
                    
                    response.sendRedirect("index.jsp");
                    return; 
                } 
                

                Product product = new Product(0, name, price, stock, categoryId);
                dao.addProduct(product);
                session.setAttribute("successMessage", "Berhasil menambah produk baru!");


            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String name = request.getParameter("name");
                int price = Integer.parseInt(request.getParameter("price"));
                int stock = Integer.parseInt(request.getParameter("stock"));
                int categoryId = Integer.parseInt(request.getParameter("categoryId"));
                
                Product product = new Product(id, name, price, stock, categoryId);
                dao.updateProduct(product);
                
                session.setAttribute("successMessage", "Produk berhasil diperbarui!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error Sistem: " + e.getMessage());
        }
        

        response.sendRedirect("index.jsp");
    }


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        try {
            if ("search".equals(action)) {
                String searchName = request.getParameter("searchName");
                List<Product> products = dao.searchProductsByName(searchName);
                
                request.setAttribute("products", products);
                request.getRequestDispatcher("index.jsp").forward(request, response);

            } else if ("delete".equals(action)) {
                String idStr = request.getParameter("id");
                if (idStr != null) {
                    int id = Integer.parseInt(idStr);
                    dao.deleteProduct(id);
                    session.setAttribute("successMessage", "Produk berhasil dihapus.");
                }
                response.sendRedirect("index.jsp");

            } else {
                response.sendRedirect("index.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp");
        }
    }
}
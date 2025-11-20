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
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

       
        try {
            if ("search".equals(action)) {
                
                String searchName = request.getParameter("searchName");

                List<Product> products = dao.searchProductsByName(searchName);

                request.setAttribute("products", products);
                
                request.getRequestDispatcher("index.jsp").forward(request, response);

            } else {
                
                List<Product> products = dao.getAllProducts();

                request.setAttribute("products", products);
           
                request.getRequestDispatcher("index.jsp").forward(request, response);
            }
        } catch (Exception e) {
            
            e.printStackTrace(); 

            
            response.sendRedirect("index.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("add".equals(action)) {
                String name = request.getParameter("name");
                if (dao.productExists(name)) {
                    request.setAttribute("error", "Produk sudah tersedia");
                    request.getRequestDispatcher("products.jsp").forward(request, response);
                    return;
                }
                int price = Integer.parseInt(request.getParameter("price"));
                int stock = Integer.parseInt(request.getParameter("stock"));
                int categoryId = Integer.parseInt(request.getParameter("categoryId"));
                Product product = new Product(0, name, price, stock, categoryId);
                dao.addProduct(product);
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String name = request.getParameter("name");
                int price = Integer.parseInt(request.getParameter("price"));
                int stock = Integer.parseInt(request.getParameter("stock"));
                int categoryId = Integer.parseInt(request.getParameter("categoryId"));
                Product product = new Product(id, name, price, stock, categoryId);
                dao.updateProduct(product);
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                dao.deleteProduct(id);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("products.jsp");
    }
}

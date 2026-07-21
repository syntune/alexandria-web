/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.Book;
import service.AdminService;
import service.BookService;
import utils.SessionUtil;

/**
 *
 * @author PC
 */
@MultipartConfig
public class AdminServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        // Returns to index.jsp if there is no session     
        if (SessionUtil.validateAdmin(request, response) == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        AdminService adminService = new AdminService();
        BookService bookService = new BookService();

        // Defaults to users page if no page parameter
        String page = request.getParameter("page");
        if (page == null || page.trim().isEmpty()) {
            page = "users";
        }
        request.setAttribute("page", page);

        // Handles actions of specific pages
        String action = request.getParameter("action");
        if (action != null) {

            // Different actions based on page value
            if (page.contentEquals("users")) {
                if (action.contentEquals("delete")) {
                    String username = request.getParameter("username");

                    adminService.deleteUser(username);
                } else if (action.contentEquals("insert")) {
                    String username = request.getParameter("username");
                    String password = request.getParameter("password");
                    int roleId = Integer.parseInt(request.getParameter("roleId"));

                    adminService.insertUser(username, password, roleId);
                } else if (action.contentEquals("update")) {
                    String username = request.getParameter("username");
                    String password = request.getParameter("password");
                    int roleId = Integer.parseInt(request.getParameter("roleId"));

                    adminService.updateUser(username, password, roleId);
                }
            } else if (page.contentEquals("publishers")) {
                if (action.contentEquals("delete")) {
                    String publisher = request.getParameter("publisher");

                    bookService.deleteTable("Publisher", publisher);
                } else if (action.contentEquals("insert")) {
                    String publisher = request.getParameter("publisher");

                    bookService.insertTable("Publisher", publisher);
                } else if (action.contentEquals("update")) {
                    String publisher = request.getParameter("publisher");
                    String newPublisher = request.getParameter("new");

                    bookService.updateTable("Publisher", publisher, newPublisher);
                }
            } else if (page.contentEquals("authors")) {
                if (action.contentEquals("delete")) {
                    String author = request.getParameter("author");

                    bookService.deleteTable("Author", author);
                } else if (action.contentEquals("insert")) {
                    String author = request.getParameter("author");

                    bookService.insertTable("Author", author);
                } else if (action.contentEquals("update")) {
                    String author = request.getParameter("author");
                    String newAuthor = request.getParameter("new");

                    bookService.updateTable("Author", author, newAuthor);
                }
            } else if (page.contentEquals("genres")) {
                if (action.contentEquals("delete")) {
                    String genre = request.getParameter("genre");

                    bookService.deleteTable("Genre", genre);
                } else if (action.contentEquals("insert")) {
                    String genre = request.getParameter("genre");

                    bookService.insertTable("Genre", genre);
                } else if (action.contentEquals("update")) {
                    String genre = request.getParameter("genre");
                    String newGenre = request.getParameter("new");

                    bookService.updateTable("Genre", genre, newGenre);
                }
            } else if (page.contentEquals("books")) {
                if (action.contentEquals("insert")) {
                    String title = request.getParameter("title");
                    String isbn = request.getParameter("isbn");
                    String description = request.getParameter("description");
                    String year = request.getParameter("year");
                    String authorId = request.getParameter("authorId");
                    String publisherId = request.getParameter("publisherId");

                    String[] genreIds = request.getParameterValues("genre");

                    // Upload directories
                    String imagePath = getServletContext().getRealPath("/images/books-cover");
                    String pdfPath = getServletContext().getRealPath("/assets/pdf");

                    // Default values
                    String imageName = null;
                    String pdfName = null;

                    // Image
                    Part imagePart = request.getPart("image");
                    if (imagePart != null
                            && imagePart.getSize() > 0
                            && imagePart.getSubmittedFileName() != null
                            && !imagePart.getSubmittedFileName().isBlank()) {

                        imageName = imagePart.getSubmittedFileName();
                        bookService.saveFile(imagePart, imagePath);
                    }

                    // PDF
                    Part pdfPart = request.getPart("pdf");
                    if (pdfPart != null
                            && pdfPart.getSize() > 0
                            && pdfPart.getSubmittedFileName() != null
                            && !pdfPart.getSubmittedFileName().isBlank()) {

                        pdfName = pdfPart.getSubmittedFileName();
                        bookService.saveFile(pdfPart, pdfPath);
                    }

                    // Save to database
                    bookService.insertBook(
                            title,
                            isbn,
                            description,
                            year,
                            authorId,
                            publisherId,
                            genreIds,
                            imageName,
                            pdfName
                    );
                } else if (action.contentEquals("delete")) {
                    String bookId = request.getParameter("bookId");
                    String image = request.getParameter("image");
                    String pdf = request.getParameter("pdf");

                    String imagePath = getServletContext().getRealPath("/images/books-cover");
                    String pdfPath = getServletContext().getRealPath("/assets/pdf");

                    bookService.deleteBook(bookId);
                    bookService.deleteFile(imagePath, image);
                    bookService.deleteFile(pdfPath, pdf);

                } else if (action.contentEquals("update")) {
                    String bookId = request.getParameter("bookId");
                    String title = request.getParameter("title");
                    String isbn = request.getParameter("isbn");
                    String description = request.getParameter("description");
                    String year = request.getParameter("year");

                    Book original = bookService.getBook(Integer.parseInt(bookId));
                    if (title == null || title.isEmpty()) {
                        title = original.getTitle();
                    }
                    if (isbn == null || isbn.isEmpty()) {
                        isbn = original.getIsbn();
                    }
                    if (description == null || description.isEmpty()) {
                        description = original.getDescription();
                    }
                    description = description + "xyz";
                    
                    if (year == null || year.isEmpty()) {
                        year = Integer.toString(original.getYear());
                    }

                    bookService.updateBook(
                            bookId,
                            title,
                            isbn,
                            description,
                            year
                    );
                }
            }

            response.sendRedirect("admin?page=" + page);
            return;
        }

        // Chooses the page to return to
        switch (page) {
            case "users" ->
                request.setAttribute("users", adminService.getUsers());
            case "books" -> {
                request.setAttribute("books", bookService.browseBooks(null, null));
                request.setAttribute("authors", bookService.getAuthors());
                request.setAttribute("publishers", bookService.getPublishers());
                request.setAttribute("genres", bookService.browseGenres());
            }
            case "authors" ->
                request.setAttribute("authors", bookService.getBookCount("Author"));
            case "publishers" ->
                request.setAttribute("publishers", bookService.getBookCount("Publisher"));
            case "genres" ->
                request.setAttribute("genres", bookService.getBookCount("Genre"));
            default -> {
                page = "users";
                request.setAttribute("page", page);
                request.setAttribute("users", adminService.getUsers());
            }
        }

        request.getRequestDispatcher("admin.jsp").forward(request, response);
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}

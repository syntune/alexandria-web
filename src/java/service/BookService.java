/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dao.BookDAO;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Book;
import model.Genre;

/**
 *
 * @author PC
 */
public class BookService {

    BookDAO bdao = new BookDAO();

    public List<Book> browseBooks(String query, String genre) {
        if (query == null && genre == null) {
            return bdao.getBooks();
        }

        return bdao.getBooks(query, genre);
    }
    
    public void insertBook(String title,
            String isbn,
            String description,
            String year,
            String authorId,
            String publisherId,
            String[] genreIds,
            String imageName,
            String pdfName) {
        
        int numYear;
        try{
            numYear = Integer.parseInt(year);
        } catch(NumberFormatException e){
           return; 
        }

        Book book = new Book();

        book.setTitle(title);
        book.setIsbn(isbn);
        book.setDescription(description);
        book.setYear(numYear);
        book.setAuthorId(Integer.parseInt(authorId));
        book.setPublisherId(Integer.parseInt(publisherId));
        book.setImage(imageName);
        book.setContentPath(pdfName);
        
        List<Integer> genreList = new ArrayList<>();
        if (genreIds != null) {
            for (String id : genreIds) {
                genreList.add(Integer.parseInt(id));
            }
        }

        int bookId = bdao.insertBook(book);
        bdao.insertBookGenres(bookId, genreList);
    }
    
    public void updateBook(String bookId, String title, String isbn, String description, String year) {
        
        int numId;
        int numYear;
        try{
            numId = Integer.parseInt(bookId);
            numYear = Integer.parseInt(year);
        } catch(NumberFormatException e){
           return; 
        }

        Book book = new Book();

        book.setTitle(title);
        book.setIsbn(isbn);
        book.setDescription(description);
        book.setYear(numYear);
       
        bdao.updateBook(numId, book);
    }
    
    public void saveFile(Part filePart, String uploadPath) {
        String fileName = filePart.getSubmittedFileName();

        File uploadDir = new File(uploadPath);

        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        
        try (
            InputStream in = filePart.getInputStream(); OutputStream out = new FileOutputStream(new File(uploadPath, fileName))) {
            in.transferTo(out);
        } catch (IOException ex) {
            Logger.getLogger(BookService.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    public void deleteFile(String filePath, String fileName) {
        File file = new File(filePath, fileName);

        if (file.exists()) {
            if (file.delete()) {
                System.out.println("File deleted successfully: " + fileName);
            } else {
                System.out.println("Failed to delete file: " + fileName);
            }
        } else {
            System.out.println("File not found: " + fileName);
        }
    }
    
    public void deleteBook(String bookId) {
        bdao.deleteBookGenres(Integer.parseInt(bookId));
        bdao.deleteBook(Integer.parseInt(bookId));
    }

    // Gets both the name and the book count
    public Map<String, Integer> getBookCount(String type) {
        if (!type.contentEquals("Author") && !type.contentEquals("Publisher") && !type.contentEquals("Genre")) {
            return null;
        }

        return bdao.getBookCountBy(type);
    }

    public List<Genre> browseGenres() {
        return bdao.getGenres();
    }

    public void insertTable(String table, String name) {

        // Prevents duplicates
        if (!bdao.checkTable(table, name)) {
            bdao.insertTable(table, name);
        }
    }
    
    public void updateTable(String table, String oldName, String newName) {

        // Only update IF exists
        if (bdao.checkTable(table, oldName)) {
            bdao.updateTable(table, oldName, newName);
        }
    }

    public void deleteTable(String table, String genre) {
        bdao.deleteTable(table, genre);
    }

    public List<Genre> getBookGenres(int bookId) {
        return bdao.getBookGenres(bookId);
    }

    public Book getBook(int bookId) {
        return bdao.getBook(bookId);
    }

    public String getBookAuthor(int bookId) {
        return bdao.getBookAuthor(bookId);
    }

    public String getAuthor(int authorId) {
        return bdao.getAuthor(authorId);
    }

    public Map<Integer, String> getAuthors() {
        return bdao.getAuthors();
    }

    public Map<Integer, String>  getPublishers() {
        return bdao.getPublishers();
    }
}

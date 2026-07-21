package dao;

import java.sql.ResultSet;
import java.sql.Statement;
import java.util.*;
import model.Book;
import model.Genre;

public class BookDAO extends MyDAO {

    // Creates a book model based on the data from the database
    private Book mapBook() throws Exception {
        Book b = new Book();

        b.setBookId(rs.getInt("ID"));
        b.setIsbn(rs.getString("ISBN"));
        b.setPublisherId(rs.getInt("PublisherID"));
        b.setAuthorId(rs.getInt("AuthorID"));
        
        b.setAuthorName(rs.getString("AuthorName"));
        b.setTitle(rs.getString("Title"));
        b.setDescription(rs.getString("Description"));
        b.setImage(rs.getString("Image"));
        b.setYear(rs.getInt("Year"));
        b.setContentPath(rs.getString("ContentPath"));

        return b;
    }

    // Insert data from a book model into the database
    public int insertBook(Book book) {
        int bookId = 0;

        xSql = "insert into Book "
                + "(ISBN, PublisherID, AuthorID, Title, Description, Year, Image, ContentPath) "
                + "values (?, ?, ?, ?, ?, ?, ?, ?)";

        try {

            ps = con.prepareStatement(xSql, Statement.RETURN_GENERATED_KEYS);

            ps.setString(1, book.getIsbn());
            ps.setInt(2, book.getPublisherId());
            ps.setInt(3, book.getAuthorId());
            ps.setString(4, book.getTitle());
            ps.setString(5, book.getDescription());
            ps.setInt(6, book.getYear());
            ps.setString(7, book.getImage());
            ps.setString(8, book.getContentPath());

            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                bookId = rs.getInt(1);
            }

            ps.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return bookId;
    }

    // Insert genres for an existing book in GenreBook
    public void insertBookGenres(int bookId, List<Integer> genreIds) {

        xSql = "insert into GenreBook(BookID, GenreID) VALUES (?, ?)";

        try {

            ps = con.prepareStatement(xSql);

            for (Integer genreId : genreIds) {
                ps.setInt(1, bookId);
                ps.setInt(2, genreId);
                ps.addBatch();
            }

            ps.executeBatch();

            ps.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateBook(int bookId, Book book) {

        xSql = "UPDATE Book "
                + "SET ISBN = ?, Title = ?, Description = ?, Year = ? "
                + "WHERE ID = ?";

        try {
            ps = con.prepareStatement(xSql);

            ps.setString(1, book.getIsbn());
            ps.setString(2, book.getTitle());
            ps.setString(3, book.getDescription());
            ps.setInt(4, book.getYear());
            ps.setInt(5, bookId);

            ps.executeUpdate();

            ps.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Deletes a book using bookId
    public void deleteBook(int bookId) {
        xSql = "delete from Book where ID = ?";

        try {
            ps = con.prepareStatement(xSql);
            ps.setInt(1, bookId);

            ps.executeUpdate();

            ps.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Delete all genres of the book with the matching Id
    public void deleteBookGenres(int bookId) {

        xSql = "DELETE FROM GenreBook WHERE BookID = ?";

        try {

            ps = con.prepareStatement(xSql);

            ps.setInt(1, bookId);

            ps.executeUpdate();

            ps.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Gets a book using bookId
    public Book getBook(int bookId) {
        Book book = null;
        xSql = """
               select b.*, a.Name as AuthorName
               from Book b
               join Author a on b.AuthorID = a.ID
               where b.ID = ?
        """;

        try {
            ps = con.prepareStatement(xSql);
            ps.setInt(1, bookId);

            rs = ps.executeQuery();

            while (rs.next()) {
                book = mapBook();
            }

            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return book;
    }

    // Gets a list of every book in the database
    public List<Book> getBooks() {
        List<Book> list = new ArrayList<>();

        xSql = """
        select b.*, a.Name as AuthorName
        from Book b
        join Author a on b.AuthorID = a.ID
    """;

        try {
            ps = con.prepareStatement(xSql);
            rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapBook());
            }

            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Gets a list of books matching the specific query search and the genre
    public List<Book> getBooks(String query, String genre) {
        List<Book> list = new ArrayList<>();

        xSql = """
            select
                b.*,
                a.Name as AuthorName
            from Book b
            join Author a on b.AuthorID = a.ID
            where (? is null or b.Title like ?)
              and (
                    ? is null
                    or exists (
                        select 1
                        from GenreBook bg
                        join Genre g on bg.GenreID = g.ID
                        where bg.BookID = b.ID
                          and lower(g.Name) = lower(?)
                    )
                  );
    """;

        try {
            ps = con.prepareStatement(xSql);

            ps.setString(1, query);
            ps.setString(2, query == null ? null : "%" + query + "%");
            ps.setString(3, genre);
            ps.setString(4, genre);

            rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapBook());
            }

            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Gets a list of genres of a book using bookId
    public List<Genre> getBookGenres(int bookId) {
        List<Genre> list = new ArrayList<>();
        xSql = "select * from Genre g join GenreBook gb on g.ID = gb.GenreID where gb.BookID = ?";

        try {
            ps = con.prepareStatement(xSql);
            ps.setInt(1, bookId);

            rs = ps.executeQuery();

            while (rs.next()) {
                list.add(new Genre(rs.getInt("ID"), rs.getString("Name")));
            }

            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Gets a list of every genres
    public List<Genre> getGenres() {
        List<Genre> list = new ArrayList<>();
        xSql = "select * from Genre";

        try {
            ps = con.prepareStatement(xSql);
            rs = ps.executeQuery();

            while (rs.next()) {
                list.add(new Genre(rs.getInt("ID"), rs.getString("Name")));
            }

            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Gets a hashmap of every authors
    public Map<Integer, String> getAuthors() {
        Map<Integer, String> authors = new LinkedHashMap<>();
        xSql = "select * from Author";

        try {
            ps = con.prepareStatement(xSql);
            rs = ps.executeQuery();

            while (rs.next()) {
                authors.put(
                        rs.getInt("ID"),
                        rs.getString("Name")
                );
            }

            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return authors;
    }

    public String getAuthor(int authorId) {
        String author = "";
        xSql = "select * from Author where ID = ?";

        try {
            ps = con.prepareStatement(xSql);
            ps.setInt(1, authorId);

            rs = ps.executeQuery();

            while (rs.next()) {
                author = rs.getString("Name");
            }

            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return author;
    }

    public String getBookAuthor(int bookId) {
        String author = "";
        xSql = "select * from Author a join Book b on a.ID = b.AuthorID where a.ID = ?";

        try {
            ps = con.prepareStatement(xSql);
            ps.setInt(1, bookId);

            rs = ps.executeQuery();

            while (rs.next()) {
                author = rs.getString("Name");
            }

            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return author;
    }

    // Gets the book count of an author/publisher/genre
    public Map<String, Integer> getBookCountBy(String type) {
        Map<String, Integer> result = new LinkedHashMap<>();

        switch (type) {
            case "Author":
                xSql = "SELECT a.Name, COUNT(b.ID) AS BookCount "
                        + "FROM Author a "
                        + "LEFT JOIN Book b ON a.ID = b.AuthorID "
                        + "GROUP BY a.ID, a.Name";
                break;

            case "Publisher":
                xSql = "SELECT p.Name, COUNT(b.ID) AS BookCount "
                        + "FROM Publisher p "
                        + "LEFT JOIN Book b ON p.ID = b.PublisherID "
                        + "GROUP BY p.ID, p.Name";
                break;

            case "Genre":
                xSql = "SELECT g.Name, COUNT(gb.BookID) AS BookCount "
                        + "FROM Genre g "
                        + "LEFT JOIN GenreBook gb ON g.ID = gb.GenreID "
                        + "GROUP BY g.ID, g.Name";
                break;

            default:
                return result;
        }

        try {
            ps = con.prepareStatement(xSql);
            rs = ps.executeQuery();

            while (rs.next()) {
                result.put(
                        rs.getString("Name"),
                        rs.getInt("BookCount")
                );
            }

            rs.close();
            ps.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }

    // Gets a map of every publisher 
    public Map<Integer, String> getPublishers() {
        Map<Integer, String> publishers = new LinkedHashMap<>();
        xSql = "select * from Publisher";

        try {
            ps = con.prepareStatement(xSql);
            rs = ps.executeQuery();

            while (rs.next()) {
                publishers.put(
                        rs.getInt("ID"),
                        rs.getString("Name")
                );
            }

            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return publishers;
    }

    // Validates table name
    private boolean isValidTable(String table) {
        return table.equals("Author")
                || table.equals("Publisher")
                || table.equals("Genre");
    }

    // Find if a name exists in a table
    public boolean checkTable(String table, String name) {
        boolean result = false;

        if (!isValidTable(table)) {
            return false;
        }

        xSql = "SELECT * FROM " + table + " WHERE Name = ?";

        try {
            ps = con.prepareStatement(xSql);
            ps.setString(1, name);

            rs = ps.executeQuery();

            if (rs.next()) {
                result = true;
            }

            rs.close();
            ps.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }

    // Inserts an author/publisher/genre into the corresopnding table
    public void insertTable(String table, String name) {

        if (!isValidTable(table)) {
            return;
        }

        xSql = "INSERT INTO " + table + " (Name) VALUES (?)";

        try {
            ps = con.prepareStatement(xSql);
            ps.setString(1, name);

            ps.executeUpdate();

            ps.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Updates an author/publisher/genre in the corresponding table
    public void updateTable(String table, String oldName, String newName) {

        if (!isValidTable(table)) {
            return;
        }

        xSql = "UPDATE " + table + " SET Name = ? WHERE Name = ?";

        try {
            ps = con.prepareStatement(xSql);
            ps.setString(1, newName);
            ps.setString(2, oldName);

            ps.executeUpdate();

            ps.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Deletes an author/publisher/genre from the corresponding table
    public void deleteTable(String table, String name) {

        if (!isValidTable(table)) {
            return;
        }

        xSql = "DELETE FROM " + table + " WHERE Name = ?";

        try {
            ps = con.prepareStatement(xSql);
            ps.setString(1, name);

            ps.executeUpdate();

            ps.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

package com.example.joeysimplebookservice;

import org.apache.coyote.Response;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/books")
@CrossOrigin(origins = "http://localhost:5173")
public class BookController {

    private final BookRepository bookRepository;

    public BookController(BookRepository bookRepository) {
        this.bookRepository = bookRepository;
    }

    @GetMapping
    public ResponseEntity<List<Book>> getBooks() {
        return ResponseEntity.ok(bookRepository.findAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<Book> getBook(@PathVariable Long id) {
        return bookRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
        }

    @PostMapping
    public ResponseEntity<Book> addBook(@RequestBody Book book) {
        book.setId(null);

        Book savedBook = bookRepository.save(book);

        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(savedBook);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteBook(@PathVariable Long id) {
        if (!bookRepository.existsById((id))) {
            return ResponseEntity.notFound().build();
        }

        bookRepository.deleteById(id);

        return ResponseEntity.noContent().build();
    }

    @PutMapping ("/{id}")
    public ResponseEntity<Book> updateBook(@PathVariable Long id, @RequestBody Book updatedBook) {
        return bookRepository.findById(id)
                .map(existingBook -> {
                    existingBook.setTitle(updatedBook.getTitle());
                    existingBook.setAuthor(updatedBook.getAuthor());
                    existingBook.setPrice(updatedBook.getPrice());

                    Book savedBook = bookRepository.save(existingBook);

                    return ResponseEntity.ok(savedBook);
                })
                .orElseGet(() -> ResponseEntity.notFound().build());
    }
}

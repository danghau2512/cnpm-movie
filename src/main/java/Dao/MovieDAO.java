package Dao;

import Model.Movie;
import Util.JdbiConnector;
import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.core.mapper.reflect.BeanMapper;

import java.util.List;

public class MovieDAO {
    private final Jdbi jdbi = JdbiConnector.getJdbi();

    public List<Movie> findAllNowShowing() {
        String sql = """
                SELECT 
                    id,
                    title,
                    duration_minutes AS durationMinutes,
                    age_rating AS ageRating,
                    short_description AS shortDescription,
                    description,
                    poster_url AS posterUrl,
                    trailer_url AS trailerUrl,
                    DATE_FORMAT(release_date, '%Y-%m-%d') AS releaseDate,
                    status
                FROM movies
                WHERE status = 'NOW_SHOWING'
                ORDER BY id DESC
                """;

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .registerRowMapper(BeanMapper.factory(Movie.class))
                        .mapTo(Movie.class)
                        .list()
        );
    }

    public List<Movie> searchMovies(String keyword) {
        String sql = """
                SELECT 
                    id,
                    title,
                    duration_minutes AS durationMinutes,
                    age_rating AS ageRating,
                    short_description AS shortDescription,
                    description,
                    poster_url AS posterUrl,
                    trailer_url AS trailerUrl,
                    DATE_FORMAT(release_date, '%Y-%m-%d') AS releaseDate,
                    status
                FROM movies
                WHERE status = 'NOW_SHOWING'
                AND title LIKE :keyword
                ORDER BY id DESC
                """;

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("keyword", "%" + keyword + "%")
                        .registerRowMapper(BeanMapper.factory(Movie.class))
                        .mapTo(Movie.class)
                        .list()
        );
    }
}
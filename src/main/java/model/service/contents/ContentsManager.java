package model.service.contents;

import java.sql.SQLException;
import java.util.List;

import model.dao.contents.BookDAO;
import model.dao.contents.ContentsDAO;
import model.dao.contents.MovieDAO;
import model.dao.contents.MusicDAO;
import model.dto.contents.Contents;

public class ContentsManager {
	private static ContentsManager contentsMan = new ContentsManager();
	private ContentsDAO contentsDAO;
	private MovieDAO movieDAO;
	private BookDAO bookDAO;
	private MusicDAO musicDAO;

	private ContentsManager() {
		try {
			contentsDAO = new ContentsDAO();
			movieDAO = new MovieDAO();
			bookDAO = new BookDAO();
			musicDAO = new MusicDAO();
		} catch (Exception e) {
			e.printStackTrace();
		}	
	}

	public static ContentsManager getInstance() {
		return contentsMan;
	}

	public List<Contents> getContentList() throws SQLException {
		return contentsDAO.getContentList();
	}
	
	public List<Contents> searchContentsByTitle(String title) throws SQLException {
		return contentsDAO.searchContentsByTitle(title);
	}
	
	public boolean pickContent(int userId, int contentsId) throws SQLException {
		return contentsDAO.pickContent(userId, contentsId);
	}
	
}
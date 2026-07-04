/**
 * Parses yt-music playlist as json. Must be execute in browser's developer console.
 * The script is AI-generated.
 */
const parsePlaylist = (reverse = false) => {
  const songs = [...document.querySelectorAll("ytmusic-playlist-shelf-renderer ytmusic-responsive-list-item-renderer")]
      .map(song => ({
          title: song.querySelector(".title")?.textContent.trim().normalize("NFKC").replace(/\[/g, "\\[").replace(/\]/g, "\\]"),
          artist: song.querySelector(".secondary-flex-columns .flex-column:nth-child(1)")?.textContent.trim().normalize("NFKC"),
          coverUrl: song.querySelector("ytmusic-thumbnail-renderer img, yt-img-shadow img")?.src,
          url: song.querySelector(".title a")?.href,
      }));

  const headers = ["No", "Title", "Artist", "Poster"];
  const rows = songs.map((song, index) => {
      const num = reverse == true ? String(songs.length - index) : String(index + 1);
      const titleCell = song.url ? `[${song.title}][${num}u]` : song.title || "";
      const artistCell = song.artist || "";
      const posterCell = song.coverUrl ? `![][${num}p]` : "";
    
      return [num, titleCell, artistCell, posterCell];
  });

  const colWidths = headers.map((header, colIndex) => {
      const maxRowWidth = rows.reduce((max, row) => Math.max(max, row[colIndex].length), 0);
      return Math.max(header.length, maxRowWidth);
  });

  const formatRow = (rowItems) => {
      return "| " + rowItems.map((item, i) => item.padEnd(colWidths[i], " ")).join(" | ") + " |";
  };

  const formattedHeaders = formatRow(headers);
  const formattedSeparator = "| " + colWidths.map(width => "-".repeat(width)).join(" | ") + " |";
  const formattedRows = rows.map(row => formatRow(row));

  const referenceLinks = [];
  songs.forEach((song, index) => {
      const num = reverse == true ? songs.length - index : index + 1;
      if (song.url) referenceLinks.push(`[${num}u]: ${song.url}`);
      if (song.coverUrl) referenceLinks.push(`[${num}p]: ${song.coverUrl}`);
  });

  const markdownOutput = [
      formattedHeaders,
      formattedSeparator,
      ...formattedRows,
      "",
      ...referenceLinks
  ].join("\n");

  return markdownOutput;
}

copy(parsePlaylist(false));

/// Repository for file operations
abstract class FileRepository {
  Future<bool> saveFileToDocuments(String sourceFilePath);
}

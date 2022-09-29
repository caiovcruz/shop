class TextFieldValidator {
  static required(
    String fieldName,
    String fieldValue,
  ) {
    return fieldValue.isEmpty ? '$fieldName is required' : null;
  }

  static minLength(
    String fieldName,
    String fieldValue,
    int minLength,
  ) {
    return fieldValue.length < minLength
        ? '$fieldName must have at least $minLength characters'
        : null;
  }

  static maxLength(
    String fieldName,
    String fieldValue,
    int maxLength,
  ) {
    return fieldValue.length > maxLength
        ? '$fieldName must have at most $maxLength characters'
        : null;
  }

    static match(
    String fieldName,
    String fieldValue,
    String matchFieldValue,
  ) {
    return fieldValue != matchFieldValue ? '$fieldName is not matching' : null;
  }

    static email(
    String fieldName,
    String fieldValue,
  ) {
    return !fieldValue.contains('@') ? '$fieldName is valid' : null;
  }

  static greaterThan(
    String fieldName,
    String fieldValue,
    double greaterThanValue,
  ) {
    return (double.tryParse(fieldValue) ?? -1) <= greaterThanValue
        ? '$fieldName must be greater than $greaterThanValue'
        : null;
  }

  static validUrl(String fieldName, String fieldValue) {
    return !(Uri.tryParse(fieldValue)?.hasAbsolutePath ?? false)
        ? '$fieldName not valid'
        : null;
  }

  static allowedFileExtensions(
    String fieldName,
    String fieldValue,
    List<String> allowedFileExtensions,
  ) {
    bool isValid = false;

    for (var extension in allowedFileExtensions) {
      if (fieldValue.toLowerCase().endsWith(extension)) {
        isValid = true;
        break;
      }
    }

    return !isValid
        ? '$fieldName must be ${allowedFileExtensions.join(', ')}'
        : null;
  }
}

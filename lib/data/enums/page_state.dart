/// Represents the various states a page can be in during its lifecycle.
enum PageState {
  DEFAULT, // Initial state of the page.
  LOADING, // Indicates the page is loading data.
  SUCCESS, // Indicates the page successfully loaded data.
  FAILED, // Indicates an error occurred while loading data.
  UPDATED, // Indicates the page content has been updated.
  CREATED, // Indicates a new resource has been created.
  NO_INTERNET, // Indicates no internet connection is available.
  MESSAGE, // Indicates a message or notification state.
  UNAUTHORIZED, // Indicates the user is not authorized to access the page.
}

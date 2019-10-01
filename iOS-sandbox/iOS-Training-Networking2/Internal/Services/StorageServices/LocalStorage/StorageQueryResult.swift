enum StorageQueryResult<T> {
    case success(T)
    case failure(Error)
}

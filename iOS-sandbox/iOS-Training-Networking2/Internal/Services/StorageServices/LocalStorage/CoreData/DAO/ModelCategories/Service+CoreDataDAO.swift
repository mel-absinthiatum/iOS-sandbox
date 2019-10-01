import CoreData

extension Service {
    func mapToDAO(context: NSManagedObjectContext) -> ServiceDAO {
        let serviceDao = ServiceDAO(context: context)
        serviceDao.id = id
        serviceDao.name = name
        serviceDao.password = password
        serviceDao.login = login
        serviceDao.serviceDescription = description
        serviceDao.url = url
        serviceDao.imageUrl = imageUrl
        return serviceDao
    }
    
    init?(dao: ServiceDAO) {
        guard let name = dao.name, let password = dao.password, let id = dao.id else {
            return nil
        }
        self.init(withName: name, password: password)
        self.id = id
        self.url = dao.url
        self.description = dao.serviceDescription
        self.imageUrl = dao.imageUrl
        self.login = dao.login
    }
}

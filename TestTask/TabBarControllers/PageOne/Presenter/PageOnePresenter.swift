import UIKit

protocol PageOnePresenterProtocol: AnyObject {
    var view: PageOneViewProtocol? { get set}
    func viewDidLoad()
}

final class PageOnePresenter: NSObject {
    weak var view: PageOneViewProtocol?
    private var flashSaleServiceObserver: NSObjectProtocol?
    private var latestServiceObserver: NSObjectProtocol?
    
    private var isProductDownLoad = (latest: false, sale: false) {
        didSet {
            if isProductDownLoad == (true, true) {
                view?.showTableView()
            }
        }
    }
    
    private enum PageOneTypeCell: CaseIterable {
        case category
        case latest
        case flashSale
        case brands
    }
}

// MARK: PageOnePresenterProtocol
extension PageOnePresenter: PageOnePresenterProtocol {
    func viewDidLoad() {
        registerObserver()
        LatestService.shared.fetchLatestProducts()
        FlashSaleService.shared.fetchLatestProducts()
    }
    
    private func registerObserver()  {
        flashSaleServiceObserver = NotificationCenter.default
            .addObserver(forName: FlashSaleService.didChangeNotification,
                         object: nil,
                         queue: .main,
                         using: { [weak self] _ in
                guard let self = self else { return }
                self.isProductDownLoad.sale = true
            })
        
        latestServiceObserver = NotificationCenter.default
            .addObserver(forName: LatestService.didChangeNotification,
                         object: nil,
                         queue: .main,
                         using: { [weak self] _ in
                guard let self = self else { return }
                self.isProductDownLoad.latest = true
            })
    }
}

// MARK: UITableViewDelegate
extension PageOnePresenter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return UIScreen.main.bounds.height / 8
        case 1, 3:
            return UIScreen.main.bounds.height / 4.5
        case 2:
            return UIScreen.main.bounds.height / 3.1
        default:
            return 0
        }
    }
}

// MARK: UITableViewDataSource
extension PageOnePresenter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        PageOneTypeCell.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        switch indexPath.row {
        case 0:
            cell = creatCategoryCell(tableView, indexPath: indexPath)
        case 1:
            cell = creatLatestTableViewCell(tableView, indexPath: indexPath)
        case 2:
            cell = creatFlashSaleTableViewCell(tableView, indexPath: indexPath)
        case 3:
            cell = creatBrandsTableViewCell(tableView, indexPath: indexPath)
        default:
           break
        }
        return cell
    }
        
    private func creatLatestTableViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LatestTableViewCell.reuseIdentifier, for: indexPath) as? LatestTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        return cell
    }
    
    private func creatCategoryCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.reuseIdentifier, for: indexPath) as? CategoryTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        return cell
    }
    
    private func creatFlashSaleTableViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FlashSaleTableViewCell.reuseIdentifier, for: indexPath) as? FlashSaleTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        return cell
    }
    
    private func creatBrandsTableViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BrandsTableViewCell.reuseIdentifier, for: indexPath) as? BrandsTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        return cell
    }
}

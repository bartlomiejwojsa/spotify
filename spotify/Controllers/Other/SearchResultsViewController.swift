//
//  SearchResultsViewController.swift
//  spotify
//
//  Created by Bartłomiej Wojsa on 04/11/2022.
//

import UIKit

struct SearchSection {
    let title: String
    let results: [SearchResult]
}

protocol SearchResultsViewControllerDelegate: AnyObject {
    func didTapResult(_ result: SearchResult)
}

class SearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: SearchResultsViewControllerDelegate?
    
    private var sections: [SearchSection] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .systemBackground
        tableView.register(SearchResultDefaultTableViewCell.self,
                           forCellReuseIdentifier: SearchResultDefaultTableViewCell.identifier)
        tableView.register(SearchResultSubtitleTableViewCell.self,
                           forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func update(with searchResults: [SearchResult]) {
        let artists = searchResults.filter {
            switch $0 {
            case .artist: return true
            default: return false
            }
        }
        let tracks = searchResults.filter {
            switch $0 {
            case .track: return true
            default: return false
            }
        }
        let playlists = searchResults.filter {
            switch $0 {
            case .playlist: return true
            default: return false
            }
        }
        let albums = searchResults.filter {
            switch $0 {
            case .album: return true
            default: return false
            }
        }
        sections = [
            SearchSection(title: "Songs", results: tracks),
            SearchSection(title: "Artists", results: artists),
            SearchSection(title: "Playlists", results: playlists),
            SearchSection(title: "Albums", results: albums)
        ]
        tableView.reloadData()
        tableView.isHidden = artists.isEmpty && tracks.isEmpty && playlists.isEmpty && albums.isEmpty
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = sections[indexPath.section].results[indexPath.row]
        var cellResult = UITableViewCell()
        switch result {
        case .artist(model: let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultDefaultTableViewCell.identifier, for: indexPath) as? SearchResultDefaultTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: SearchResultDefaultTableViewCellViewModel(
                title: model.name,
                imageURL: URL(string: model.images?.first?.url ?? "")
            ))
            cellResult = cell
        case .playlist(model: let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultSubtitleTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: SearchResultSubtitleTableViewCellViewModel(
                title: model.name,
                subtitle: model.owner.display_name,
                imageURL: URL(string: model.images.first?.url ?? "")
            ))
            cellResult = cell
        case .album(model: let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultSubtitleTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: SearchResultSubtitleTableViewCellViewModel(
                title: model.name,
                subtitle: model.artists.first?.name ?? "",
                imageURL: URL(string: model.images.first?.url ?? "")
            ))
            cellResult = cell
        case .track(model: let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultSubtitleTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: SearchResultSubtitleTableViewCellViewModel(
                title: model.name,
                subtitle: model.artists.first?.name ?? "",
                imageURL: URL(string: model.album?.images.first?.url ?? "")
            ))
            cellResult = cell
        }
        return cellResult
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let result = sections[indexPath.section].results[indexPath.row]
        delegate?.didTapResult(result)
    }
    
}

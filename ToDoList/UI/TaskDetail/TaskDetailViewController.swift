//
//  TaskDetailViewController.swift
//  ToDoList
//
//  Created by Rashid Gaitov on 21.02.2025.
//

import Foundation
import UIKit

protocol TaskDetailView {
    func show(task: Task)
    func displayUpdatedTask(_ task: Task)
}

final class TaskDetailViewController: UIViewController, TaskDetailView {
    
    private var task = Task(id: 1, title: "Заняться спортом ", description: "Составить список необходимых продуктов для ужина. Не забыть проверить, что уже есть в холодильнике.", creationDate: Date(), isCompleted: false)
    private var presenter: TaskDetailPresenter
    
    private var titleTextView = UITextView()
    private var descriptionTextView = UITextView()
    private var dateLabel = UILabel()
    
    func show(task: Task) {
        self.task = task
    }
    
    init(presenter: TaskDetailPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.editTask(task: task)
    }
    
    func displayUpdatedTask(_ task: Task) {
        
    }
    
    private func setUpView() {
        
        titleTextView.text = task.title
        titleTextView.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        titleTextView.isEditable = true
        titleTextView.isScrollEnabled = false
        titleTextView.translatesAutoresizingMaskIntoConstraints = false
        titleTextView.textContainerInset = .zero
        titleTextView.textContainer.lineFragmentPadding = 0
        titleTextView.delegate = self
        view.addSubview(titleTextView)
        
        // Configure date label
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateLabel.text = dateFormatter.string(from: task.creationDate)
        dateLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        dateLabel.textColor = .gray
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dateLabel)
        
        descriptionTextView.text = task.description
        descriptionTextView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        descriptionTextView.isEditable = true
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.textContainerInset = UIEdgeInsets.zero
        descriptionTextView.textContainer.lineFragmentPadding = 0
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.delegate = self
        view.addSubview(descriptionTextView)
        
        NSLayoutConstraint.activate([
            titleTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            titleTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            dateLabel.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            descriptionTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}

extension TaskDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView == titleTextView {
            task.title = textView.text
        }
        
        if textView == descriptionTextView {
            task.description = textView.text
        }
    }
}

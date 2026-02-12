//
//  ViewController.swift
//  NotasCoreData
//
//  Created by Carlos Alfredo Call on 20/1/26.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var txtNota: UITextField!
    @IBOutlet weak var tableView: UITableView!

    private var notas: [Nota] = []

    private var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self

        cargarNotas()
    }

    @IBAction func guardarNota(_ sender: UIButton) {
        let texto = (txtNota.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !texto.isEmpty else { return }

        let nueva = Nota(context: context)
        nueva.texto = texto
        nueva.fecha = Date()

        do {
            try context.save()
            txtNota.text = ""
            cargarNotas()
        } catch {
            print("Error guardando nota: \(error)")
        }
    }

    private func cargarNotas() {
        let request: NSFetchRequest<Nota> = Nota.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "fecha", ascending: false)]

        do {
            notas = try context.fetch(request)
            tableView.reloadData()
        } catch {
            print("Error cargando notas: \(error)")
        }
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")

        let nota = notas[indexPath.row]
        cell.textLabel?.text = nota.texto

        if let fecha = nota.fecha {
            let df = DateFormatter()
            df.dateStyle = .short
            df.timeStyle = .short
            cell.detailTextLabel?.text = df.string(from: fecha)
        } else {
            cell.detailTextLabel?.text = nil
        }

        return cell
    }

    // (Opcional) Swipe para borrar
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let nota = notas[indexPath.row]
            context.delete(nota)

            do {
                try context.save()
                cargarNotas()
            } catch {
                print("Error borrando nota: \(error)")
            }
        }
    }
}

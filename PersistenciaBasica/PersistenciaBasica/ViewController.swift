//
//  ViewController.swift
//  PersistenciaBasica
//
//  Created by Carlos Alfredo Call on 19/1/26.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textoTextView: UITextView!
    @IBOutlet weak var fechaLabel: UILabel!

    var fechaEdicion: Date?

    // Claves de UserDefaults
    private let kTexto = "texto"
    private let kFecha = "fecha"

    override func viewDidLoad() {
        super.viewDidLoad()

        // 1) Recuperar texto
        let prefs = UserDefaults.standard
        if let textoGuardado = prefs.string(forKey: kTexto) {
            textoTextView.text = textoGuardado
        }

        // 2) Recuperar fecha (como objeto)
        if let fechaObj = prefs.object(forKey: kFecha) as? Date {
            fechaEdicion = fechaObj
            fechaLabel.text = DateFormatter.localizedString(
                from: fechaObj,
                dateStyle: .short,
                timeStyle: .medium
            )
        } else {
            fechaLabel.text = "Sin fecha"
        }
    }

    @IBAction func guardarTapped(_ sender: UIButton) {

        // 1) Actualizar fechaEdicion
        fechaEdicion = Date()

        // 2) Mostrar fecha en el label
        fechaLabel.text = DateFormatter.localizedString(
            from: fechaEdicion!,
            dateStyle: .short,
            timeStyle: .medium
        )

        // 3) Guardar en preferencias
        let prefs = UserDefaults.standard
        prefs.set(textoTextView.text, forKey: kTexto)
        prefs.set(fechaEdicion!, forKey: kFecha)

        // (opcional) Forzar guardado inmediato para pruebas
        prefs.synchronize()
    }
}

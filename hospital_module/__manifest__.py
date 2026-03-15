# -*- coding: utf-8 -*-
{
    'name': 'Hospital Management',
    'version': '18.0.1.0.0',
    'category': 'Healthcare',
    'summary': 'Simple Hospital Management Module for Odoo 18',
    'description': """
        Hospital Management System
        ==========================
        A simple hospital management module featuring:
        - Patient Registration
        - Doctor Management
        - Appointment Scheduling
        - Medical Records
    """,
    'author': 'Demo CI/CD Project',
    'website': 'https://github.com/your-org/odoo-cicd-demo',
    'license': 'LGPL-3',
    'depends': ['base', 'mail'],
    'data': [
        'security/ir.model.access.csv',
        'views/patient_views.xml',
        'views/doctor_views.xml',
        'views/appointment_views.xml',
        'views/menu_views.xml',
        'data/demo_data.xml',
    ],
    'demo': [],
    'installable': True,
    'application': True,
    'auto_install': False,
}

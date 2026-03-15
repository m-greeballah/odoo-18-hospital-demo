# -*- coding: utf-8 -*-
from odoo import models, fields, api


class HospitalDoctor(models.Model):
    _name = 'hospital.doctor'
    _description = 'Hospital Doctor'
    _inherit = ['mail.thread', 'mail.activity.mixin']

    name = fields.Char(string='Doctor Name', required=True, tracking=True)
    ref = fields.Char(string='Doctor Reference', readonly=True, default='New')
    specialization = fields.Selection([
        ('general', 'General Practitioner'),
        ('cardiology', 'Cardiology'),
        ('neurology', 'Neurology'),
        ('orthopedics', 'Orthopedics'),
        ('pediatrics', 'Pediatrics'),
        ('dermatology', 'Dermatology'),
        ('ophthalmology', 'Ophthalmology'),
        ('psychiatry', 'Psychiatry'),
    ], string='Specialization', required=True)
    phone = fields.Char(string='Phone')
    email = fields.Char(string='Email')
    degree = fields.Char(string='Degree')
    experience_years = fields.Integer(string='Years of Experience')
    patient_ids = fields.One2many('hospital.patient', 'doctor_id', string='Patients')
    patient_count = fields.Integer(string='Patient Count', compute='_compute_patient_count')
    appointment_ids = fields.One2many('hospital.appointment', 'doctor_id', string='Appointments')
    is_available = fields.Boolean(string='Available', default=True, tracking=True)

    @api.model_create_multi
    def create(self, vals_list):
        for vals in vals_list:
            if vals.get('ref', 'New') == 'New':
                vals['ref'] = self.env['ir.sequence'].next_by_code('hospital.doctor') or 'New'
        return super().create(vals_list)

    def _compute_patient_count(self):
        for rec in self:
            rec.patient_count = self.env['hospital.patient'].search_count(
                [('doctor_id', '=', rec.id)]
            )

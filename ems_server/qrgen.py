# coding:utf-8
from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import A4
from reportlab.lib.units import mm
from reportlab.graphics.barcode import code39, qr
from reportlab.pdfbase.cidfonts import UnicodeCIDFont
from reportlab.pdfbase import pdfmetrics
import random
from io import StringIO


class QrGen:
    def __init__(self):
        self.cell_sum = 0
        self.cell_width = 35.0 + 2.0
        self.cell_height = 12.0 + 2.0
        self.cell_column = 5
        self.cell_line = 19
        self.x_margin = 12.5 * mm
        self.y_margin = 15.5 * mm

    def _draw_label(self, qr_sheet, x, y, hashcode, code, name):
        qr_sheet.setLineWidth(0.5)
        qr_sheet.rect(x, y, self.cell_width * mm, self.cell_height * mm, stroke=1, fill=0)
        qr_sheet.setFont("HeiseiKakuGo-W5", 6.5)
        qr_sheet.drawCentredString(x + 15.0 * mm, y + 9 * mm, name[:10], 0, wordSpace=(self.cell_width+15))
        qr_sheet.drawCentredString(x + 15.0 * mm, y + 6 * mm, code[:15], 0, wordSpace=(self.cell_width+15))

        # qr_sheet.drawString(x + 15.0 * mm, y + 9 * mm, data)
        # qr_sheet.drawString(x + 15.0 * mm, y + 6 * mm, name)

        cell = qr.QrCode(hashcode)
        cell.width = 40
        cell.height = 40
        cell.hAlign = "CENTER"
        cell.drawOn(qr_sheet, x, y)

    def pdf(self, data: [[str]]) -> canvas:
        self.cell_sum = len(data)
        pdfmetrics.registerFont(UnicodeCIDFont("HeiseiKakuGo-W5"))
        pdfmetrics.registerFont(UnicodeCIDFont('HeiseiMin-W3'))
        fp = StringIO()
        pdf = canvas.Canvas(fp, pagesize=A4)

        print(len(data))
        print(data)
        i = 0
        for count in range(self.cell_sum):
            if count % 95 == 0 and count != 0:
                pdf.showPage()
                i = 0

            x = self.x_margin + (self.cell_width * mm) * (i % self.cell_column)
            y = self.y_margin + (self.cell_height * mm) * ((self.cell_line - 1) - (i // self.cell_column))
            self._draw_label(pdf, x, y, hashcode=data[i][0], code=data[i][1], name=data[i][2])
            i += 1
        out = pdf.getpdfdata()
        fp.close()
        return out



    @staticmethod
    def _get_random_code():
        s = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        return "".join([random.choice(s) for i in range(8)])


if __name__ == '__main__':
    QrGen().pdf(data=[["111","test"]]).save()

#pragma once
#include <QObject>

class Car : public QObject
{
     Q_OBJECT
public:
    explicit Car(QObject *parent = nullptr);
    Car(int x, int y, int orientation, int isRed, int length, QString color);
    Car(const Car &other);

    QString toString() const;
    //public all the way, because
    //I'm beeing lazy with setters and getters :D
    ///TODO move to private and add setter/getter 26/08/2025
    int x,y;
    int orientation;
    int isRed;
    int length;
    QString color;
    QString name;
    int carIdx;
    int dragMinX, dragMaxX;
    int dragMinY, dragMaxY;

};




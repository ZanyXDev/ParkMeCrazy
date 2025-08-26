#include "car.h"

Car::Car(QObject *parent)
    : QObject{parent}
{

}

Car::Car(const Car &other)
{
    this->x = other.x;
    this->y = other.y;
    this->orientation = other.orientation;
    this->isRed = other.isRed;
    this->length = other.length;
    this->color.clear();
    this->color.append(other.color);
    this->name.clear();
    this->name.append(other.name);
    this->carIdx = other.carIdx;
    this->dragMaxX = other.dragMaxX;
    this->dragMaxY = other.dragMaxY;
    this->dragMinX = other.dragMinX;
    this->dragMinY = other.dragMinY;
}

Car::Car(int x, int y, int orientation, int isRed, int length, QString color) :
    x(x), y(y),
    orientation(orientation),
    isRed(isRed),
    length(length),
    color(color),
    name("NN"),
    carIdx(0),
    dragMinX(0),
    dragMaxX(0),
    dragMinY(0),
    dragMaxY(0)
{
}

QString Car::toString() const
{
    QString ret = QString("%1,%2,%3,%4,%5,%6").arg(x).arg(y).arg(orientation).arg(isRed).arg(length).append(color);
    return ret;
}




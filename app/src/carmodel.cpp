#include "carmodel.h"
CarModel::CarModel(QObject *parent)
    : QAbstractListModel{parent}
{}

QHash<int, QByteArray> CarModel::roleNames() const
{
    static QHash<int, QByteArray> roles;
    if (roles.isEmpty()) {
        roles[XRole] = "X";
        roles[YRole] = "Y";
        roles[OrientationRole] = "Orientation";
        roles[IsRedRole] = "IsRed";
        roles[LengthRole] = "Length";
        roles[ColorRole] = "Color";
        roles[NameRole] = "Name";
        roles[CarIdxRole] = "CarIdx";
        roles[DragMinX] = "DragMinX";
        roles[DragMaxX] = "DragMaxX";
        roles[DragMinY] = "DragMinY";
        roles[DragMaxY] = "DragMaxY";
    }
    return roles;
}

int CarModel::rowCount(const QModelIndex &parent) const
{
    return parent.isValid() ? 0 : m_cars.count();
}

int CarModel::columnCount(const QModelIndex &parent) const
{
    // QAbstractListModel предполагает одну колонку (т.е. columnCount() == 1)
    // а роли это не ячейки в строке, а дополнительные ствойства конкретной ячейки!!!!!
    Q_UNUSED(parent);
    return 1;
}

QVariant CarModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_cars.count() )
        return QVariant();
    Car *c = m_cars[index.row()];
    const Car &car = *c;
    switch(role) {
    case XRole: return car.x;
    case YRole: return car.y;
    case OrientationRole: return car.orientation;
    case IsRedRole: return car.isRed;
    case LengthRole: return car.length;
    case ColorRole: return car.color;
    case NameRole: return car.name;
    case CarIdxRole: return car.carIdx;
    case DragMinX : return car.dragMinX;
    case DragMaxX : return car.dragMaxX;
    case DragMinY : return car.dragMinY;
    case DragMaxY : return car.dragMaxY;
    default: return QVariant();
    }
}

Qt::ItemFlags CarModel::flags(const QModelIndex &index) const
{
    if (!index.isValid()) return Qt::NoItemFlags;
    return Qt::ItemIsSelectable | Qt::ItemIsEnabled | Qt::ItemIsEditable;
}

QModelIndex CarModel::index(int row, int column, const QModelIndex &parent) const
{
    if (!hasIndex(row, column, parent)) return QModelIndex();
    return createIndex(row, column);
}

QModelIndex CarModel::parent(const QModelIndex &index) const
{
    Q_UNUSED(index);
    return QModelIndex(); // Плоская структура данных
}

void CarModel::clear()
{
    beginResetModel();
    m_cars.clear();
    endResetModel();
}

void CarModel::addCar(Car *car)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    m_cars << car;
    endInsertRows();
}

Car* CarModel::getCarAt(int index)
{
    return m_cars.at(index);
}

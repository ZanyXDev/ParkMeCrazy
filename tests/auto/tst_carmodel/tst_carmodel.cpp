#include "tst_boardmodel.h"

#include <QtTest/QtTest>

TestCarModel::TestCarModel() {}

TestCarModel::~TestCarModel() {}

void TestCarModel::initTestCase()
{
    m_tester = new QAbstractItemModelTester(&m_model);
}

void TestCarModel::init()
{
    this->testClear();
}

void TestCarModel::testRowCount()
{
    QCOMPARE(m_model.rowCount(), 0);
//    m_model.addCell("#FF0000");
    QCOMPARE(m_model.rowCount(), 1);
}



void TestCarModel::testAddCell()
{
    QSignalSpy rowInsertedSpy(&m_model, &CarModel::rowsInserted);

    //m_model.addCell("#0000FF");

    //QVERIFY(rowInsertedSpy.isValid());
    //QCOMPARE(m_model.rowCount(), 1);
    //QVERIFY(rowInsertedSpy.count() == 1);
}

void TestCarModel::testDataChanged()
{
    QSignalSpy dataChangedSpy(&m_model, &CarModel::dataChanged);

    m_model.addCell("#000000");
    QModelIndex idx = m_model.index(0, 0);
    QVERIFY2(idx.isValid(),"For first item index must be 0 and valid.");
    QVERIFY(dataChangedSpy.isValid());

    auto test_role = [&](bool mode) {
        // Проверяем, что сигнал испускался один раз
        QCOMPARE(dataChangedSpy.count(), 1);

        // Получаем аргументы сигнала
        auto args = dataChangedSpy.takeFirst();

        // Проверяем topLeft и bottomRight
        QCOMPARE(args.at(0).value<QModelIndex>(), idx);
        QCOMPARE(args.at(1).value<QModelIndex>(), idx);

        // Проверяем, что роль была в списке изменённых ролей
        QVector<int> roles = args.at(2).value<QVector<int>>();
        qDebug() << "roles:" <<roles;
        if ( mode ) {
            QVERIFY( roles.contains(BoardModel::ColorRole) ) ;
        }
        else{
            QVERIFY( roles.contains(BoardModel::FilledRole) );
        }
    };
    // Изменяем цвет
    QVERIFY(m_model.setData(idx, "#FF0000", BoardModel::ColorRole));
    test_role(true);
    QVERIFY(m_model.setData(idx, false, BoardModel::FilledRole));
    test_role(false);

    //Проверка что не изменился цвет
    QCOMPARE(m_model.setData(idx, "#FF0003", Qt::DisplayRole),false);
    QCOMPARE(m_model.data(idx, Qt::DisplayRole), QVariant());

    // Проверяем что не поддерживаемые роли не вызвают сигнал dataChanged
    QCOMPARE(m_model.setData(idx, "#FF0003", Qt::DisplayRole),false);
    QCOMPARE(dataChangedSpy.count(), 0);
}


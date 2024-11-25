import 'package:exemplo_firebase/screens/profile_screen_view.dart';
import 'package:exemplo_firebase/screens/selection_screen_view.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String name;
  final String cpf;
  final String email;
  final String imagem;

  const HomePage({
    super.key,
    required this.name,
    required this.imagem,
    required this.cpf,
    required this.email,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showCards = false;
  int _selectedIndex = 0;
  bool isCalendarExpanded =
      false; // Estado para controlar a expansão do calendário
  DateTime selectedDate = DateTime.now(); // Data selecionada inicialmente

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 223, 209, 186),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 223, 209, 186),
        elevation: 0,
        title: Text(
          'Olá, ${widget.name}!',
          style: TextStyle(
            fontSize: screenWidth * 0.06,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 56, 128, 59),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () => _navigateToProfile(),
            child: CircleAvatar(
              radius: screenWidth * 0.06,
              backgroundColor: Colors.white,
              child: widget.imagem.isNotEmpty
                  ? ClipOval(
                      child: Image.network(
                        widget.imagem,
                        fit: BoxFit.cover,
                        width: screenWidth * 0.12,
                        height: screenWidth * 0.12,
                      ),
                    )
                  : const Icon(Icons.person,
                      size: 30, color: Color(0xFF7B2CBF)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.03),
              _buildWeekDays(),
              SizedBox(height: screenHeight * 0.03),
              SizedBox(
                height: screenHeight * 0.6,
                child: Center(
                  child: showCards ? _buildCards() : _buildImageAndText(),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  void _onBottomNavigationTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        _navigateToProfile();
        break;
      case 2:
        _navigateToSelectionScreen();
        break;
      case 3:
        break;
    }
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(
          name: widget.name,
          email: widget.email,
          cpf: widget.cpf,
          imagem: widget.imagem,
        ),
      ),
    );
  }

  void _navigateToSelectionScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionScreenView(
          imagem: widget.imagem,
        ),
      ),
    );
  }

  Widget _buildImageAndText() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/banner_inicial.png',
          height: screenHeight * 0.4,
          fit: BoxFit.cover,
        ),
        SizedBox(height: screenHeight * 0.02),
        const Text(
          'Você ainda não realizou nenhuma coleta!',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: screenHeight * 0.06),
        ElevatedButton.icon(
          onPressed: _navigateToSelectionScreen,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(149, 5, 23, 5),
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.08, vertical: screenHeight * 0.02),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          icon: const Icon(Icons.add, color: Colors.white, size: 20),
          label: const Text(
            'Realize sua coleta',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildCards() {
    final screenWidth = MediaQuery.of(context).size.width;

    return ListView.builder(
      itemCount: 9,
      itemBuilder: (context, index) => Card(
        shadowColor: const Color.fromARGB(255, 0, 0, 0),
        color: const Color.fromRGBO(218, 194, 162, 1),
        margin: EdgeInsets.symmetric(vertical: screenWidth * 0.03),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/folhas2.png',
                  width: screenWidth * 0.2,
                  height: screenWidth * 0.2,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: screenWidth * 0.03),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Produto ${index + 1}',
                      style: TextStyle(
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.02),
                    const Text(
                      'DATA DE Criação\nDATA DE COLETA',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.add,
                color: Colors.green,
                size: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeekDays() {
    final screenWidth = MediaQuery.of(context).size.width;

    DateTime now = DateTime.now();
    DateTime firstDayOfWeek = now.subtract(Duration(days: now.weekday));

    List<DateTime> weekDays = List.generate(7, (index) {
      return firstDayOfWeek.add(Duration(days: index));
    });

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isCalendarExpanded = !isCalendarExpanded;
            });
          },
          child: Text(
            '${now.month}/${now.year}',
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
              color: Colors.blue, // Mudança de cor para destacar o mês
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7, // 7 dias por semana
            mainAxisSpacing: screenWidth * 0.02,
            crossAxisSpacing: screenWidth * 0.02,
          ),
          itemCount: weekDays.length,
          itemBuilder: (context, index) {
            DateTime currentDay = weekDays[index];
            bool isToday = currentDay.day == now.day;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedDate = currentDay;
                  isCalendarExpanded = true; // Expandir após seleção
                });
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(screenWidth * 0.02),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentDay == selectedDate
                      ? Colors.blue
                      : Colors.transparent,
                ),
                child: Text(
                  '${currentDay.day}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: currentDay == selectedDate
                        ? Colors.white
                        : (isToday ? Colors.red : Colors.black),
                  ),
                ),
              ),
            );
          },
        ),
        if (isCalendarExpanded) _buildFullMonthCalendar(now),
      ],
    );
  }

  Widget _buildFullMonthCalendar(DateTime now) {
    final screenWidth = MediaQuery.of(context).size.width;

    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    int daysInMonth = lastDayOfMonth.day;
    DateTime firstDayOfCalendar =
        firstDayOfMonth.subtract(Duration(days: firstDayOfMonth.weekday));

    List<DateTime> monthDays = List.generate(
      (firstDayOfCalendar.day + daysInMonth),
      (index) => firstDayOfCalendar.add(Duration(days: index)),
    );

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: screenWidth * 0.02,
        crossAxisSpacing: screenWidth * 0.02,
      ),
      itemCount: monthDays.length,
      itemBuilder: (context, index) {
        DateTime currentDay = monthDays[index];
        bool isToday = currentDay.day == now.day;
        bool isCurrentMonth = currentDay.month == now.month;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedDate = currentDay;
            });
          },
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(screenWidth * 0.02),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  currentDay == selectedDate ? Colors.blue : Colors.transparent,
            ),
            child: Text(
              '${currentDay.day}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: currentDay == selectedDate
                    ? Colors.white
                    : (isCurrentMonth
                        ? (isToday ? Colors.red : Colors.black)
                        : Colors.grey),
              ),
            ),
          ),
        );
      },
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: const Color.fromARGB(255, 223, 209, 186),
      currentIndex: _selectedIndex,
      onTap: _onBottomNavigationTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt),
          label: 'Coletar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Configurações',
        ),
      ],
    );
  }
}

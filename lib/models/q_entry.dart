/// Q(state, action) 的單一項目：累計獎勵與次數，Laplace 先驗避免 count=0
class QEntry {
  int sum;
  int count;
  QEntry({this.sum = 0, this.count = 1});
  double get value => sum / count;
}

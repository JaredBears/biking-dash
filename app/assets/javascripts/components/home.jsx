
class Home extends React.Component {
  render() {
    return (
      <div>
        <h1>Home</h1>
        <button onClick={this.handleNewReport}>New Report</button>
        <button onClick={this.handleReports}>Reports</button>
        <div id="box">Test</div>
      </div>
    );
  }
  handleNewReport() {
    box = document.getElementById('box');
    box.innerHTML = '<NewReport />'
  }

  handleReports() {
    box = document.getElementById('box');
    box.innerHTML = '<Reports />'
  }
}

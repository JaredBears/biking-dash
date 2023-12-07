window.Report = createReactClass({
  render: function() {
    return (
      <div className="report">
        <h1>{this.props.title}</h1>
        <p>{this.props.content}</p>
      </div>
    );
  }
});

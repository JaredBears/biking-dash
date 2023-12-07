window.Home = createReactClass({
  render: function() {
    return (
      <div className="page">
        <h1>{this.props.title}</h1>
        <p>{this.props.content}</p>
      </div>
    );
  }
});
